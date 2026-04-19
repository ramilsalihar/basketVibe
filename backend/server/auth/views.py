from django.contrib.auth.models import User
from google.auth.transport import requests as google_requests
from google.oauth2 import id_token
from rest_framework import status
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken

from django.conf import settings
from server.models import UserProfile


class GoogleLoginView(APIView):
    """
    Accepts a Google ID token from the Flutter app and returns JWT tokens.

    POST /api/auth/google/
    Body: { "id_token": "<google_id_token>" }
    Response: { "access": "...", "refresh": "...", "user": { "id", "email", "name" } }
    """
    permission_classes = [AllowAny]

    def post(self, request):
        token = request.data.get('id_token')
        if not token:
            return Response({'error': 'id_token is required.'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            id_info = id_token.verify_oauth2_token(
                token,
                google_requests.Request(),
                settings.GOOGLE_CLIENT_ID,
            )
        except ValueError as e:
            return Response({'error': f'Invalid token: {e}'}, status=status.HTTP_401_UNAUTHORIZED)

        google_id = id_info['sub']
        email = id_info.get('email', '')
        name = id_info.get('name', '')
        picture = id_info.get('picture', '')
        first_name, _, last_name = name.partition(' ')

        user, created = User.objects.get_or_create(
            username=google_id,
            defaults={
                'email': email,
                'first_name': first_name,
                'last_name': last_name,
            },
        )

        UserProfile.objects.update_or_create(
            google_id=google_id,
            defaults={'user': user, 'avatar_url': picture},
        )

        refresh = RefreshToken.for_user(user)
        return Response({
            'access': str(refresh.access_token),
            'refresh': str(refresh),
            'user': {
                'id': user.id,
                'email': user.email,
                'name': name,
                'avatar_url': picture,
                'is_new': created,
            },
        }, status=status.HTTP_200_OK)
