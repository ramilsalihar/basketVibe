from django.urls import path
from rest_framework_simplejwt.views import TokenRefreshView

from .views import GoogleLoginView

urlpatterns = [
    path('google/', GoogleLoginView.as_view(), name='google-login'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token-refresh'),
]
