from datetime import timedelta
from unittest.mock import patch

from django.contrib.auth.models import User
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from rest_framework_simplejwt.tokens import RefreshToken

from server.models import UserProfile

GOOGLE_LOGIN_URL = reverse('google-login')
TOKEN_REFRESH_URL = reverse('token-refresh')

MOCK_ID_INFO = {
    'sub': '123456789',
    'email': 'player@example.com',
    'name': 'Alex Dunk',
    'picture': 'https://lh3.googleusercontent.com/photo.jpg',
}


class GoogleLoginViewTests(APITestCase):

    @patch('server.auth.views.id_token.verify_oauth2_token')
    def test_new_user_is_created_and_returns_tokens(self, mock_verify):
        mock_verify.return_value = MOCK_ID_INFO

        response = self.client.post(GOOGLE_LOGIN_URL, {'id_token': 'valid-token'}, format='json')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('access', response.data)
        self.assertIn('refresh', response.data)

        user_data = response.data['user']
        self.assertEqual(user_data['email'], 'player@example.com')
        self.assertEqual(user_data['name'], 'Alex Dunk')
        self.assertTrue(user_data['is_new'])

        self.assertTrue(User.objects.filter(username='123456789').exists())
        self.assertTrue(UserProfile.objects.filter(google_id='123456789').exists())

    @patch('server.auth.views.id_token.verify_oauth2_token')
    def test_existing_user_is_returned_not_duplicated(self, mock_verify):
        mock_verify.return_value = MOCK_ID_INFO
        user = User.objects.create(username='123456789', email='player@example.com')
        UserProfile.objects.create(user=user, google_id='123456789')

        response = self.client.post(GOOGLE_LOGIN_URL, {'id_token': 'valid-token'}, format='json')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertFalse(response.data['user']['is_new'])
        self.assertEqual(User.objects.filter(username='123456789').count(), 1)

    @patch('server.auth.views.id_token.verify_oauth2_token')
    def test_avatar_url_is_updated_on_login(self, mock_verify):
        updated_info = {**MOCK_ID_INFO, 'picture': 'https://new-photo.jpg'}
        mock_verify.return_value = updated_info
        user = User.objects.create(username='123456789', email='player@example.com')
        UserProfile.objects.create(user=user, google_id='123456789', avatar_url='https://old-photo.jpg')

        self.client.post(GOOGLE_LOGIN_URL, {'id_token': 'valid-token'}, format='json')

        profile = UserProfile.objects.get(google_id='123456789')
        self.assertEqual(profile.avatar_url, 'https://new-photo.jpg')

    def test_missing_id_token_returns_400(self):
        response = self.client.post(GOOGLE_LOGIN_URL, {}, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('error', response.data)

    @patch('server.auth.views.id_token.verify_oauth2_token', side_effect=ValueError('Token expired'))
    def test_invalid_id_token_returns_401(self, mock_verify):
        response = self.client.post(GOOGLE_LOGIN_URL, {'id_token': 'bad-token'}, format='json')

        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
        self.assertIn('error', response.data)

    @patch('server.auth.views.id_token.verify_oauth2_token')
    def test_endpoint_is_publicly_accessible(self, mock_verify):
        mock_verify.return_value = MOCK_ID_INFO

        response = self.client.post(GOOGLE_LOGIN_URL, {'id_token': 'valid-token'}, format='json')

        self.assertEqual(response.status_code, status.HTTP_200_OK)

    @patch('server.auth.views.id_token.verify_oauth2_token')
    def test_missing_email_in_token_creates_user_with_blank_email(self, mock_verify):
        # id_info with no 'email' key — view uses .get('email', '')
        mock_verify.return_value = {'sub': '999', 'name': 'No Email', 'picture': ''}

        response = self.client.post(GOOGLE_LOGIN_URL, {'id_token': 'valid-token'}, format='json')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        user = User.objects.get(username='999')
        self.assertEqual(user.email, '')
        self.assertEqual(response.data['user']['email'], '')

    @patch('server.auth.views.id_token.verify_oauth2_token')
    def test_missing_name_in_token_creates_user_with_blank_name(self, mock_verify):
        # id_info with no 'name' key — view uses .get('name', '')
        mock_verify.return_value = {'sub': '888', 'email': 'noname@example.com', 'picture': ''}

        response = self.client.post(GOOGLE_LOGIN_URL, {'id_token': 'valid-token'}, format='json')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        user = User.objects.get(username='888')
        self.assertEqual(user.first_name, '')
        self.assertEqual(user.last_name, '')

    @patch('server.auth.views.id_token.verify_oauth2_token')
    def test_new_user_profile_stores_avatar_url(self, mock_verify):
        mock_verify.return_value = MOCK_ID_INFO

        self.client.post(GOOGLE_LOGIN_URL, {'id_token': 'valid-token'}, format='json')

        profile = UserProfile.objects.get(google_id='123456789')
        self.assertEqual(profile.avatar_url, MOCK_ID_INFO['picture'])


class TokenRefreshViewTests(APITestCase):

    def setUp(self):
        self.user = User.objects.create(username='testuser')

    def test_valid_refresh_token_returns_new_access_token(self):
        refresh = RefreshToken.for_user(self.user)

        response = self.client.post(TOKEN_REFRESH_URL, {'refresh': str(refresh)}, format='json')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('access', response.data)

    def test_invalid_refresh_token_returns_401(self):
        response = self.client.post(TOKEN_REFRESH_URL, {'refresh': 'not-a-token'}, format='json')

        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_missing_refresh_token_returns_400(self):
        response = self.client.post(TOKEN_REFRESH_URL, {}, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_rotation_returns_new_refresh_token(self):
        # ROTATE_REFRESH_TOKENS=True means a fresh refresh token must be returned
        refresh = RefreshToken.for_user(self.user)
        original = str(refresh)

        response = self.client.post(TOKEN_REFRESH_URL, {'refresh': original}, format='json')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('refresh', response.data)
        self.assertNotEqual(response.data['refresh'], original)

    def test_expired_refresh_token_returns_401(self):
        refresh = RefreshToken.for_user(self.user)
        refresh.set_exp(lifetime=timedelta(seconds=-1))

        response = self.client.post(TOKEN_REFRESH_URL, {'refresh': str(refresh)}, format='json')

        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_access_token_cannot_be_used_as_refresh_token(self):
        refresh = RefreshToken.for_user(self.user)
        access_token = str(refresh.access_token)

        response = self.client.post(TOKEN_REFRESH_URL, {'refresh': access_token}, format='json')

        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
