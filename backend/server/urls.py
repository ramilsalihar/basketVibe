from django.urls import include, path

urlpatterns = [
    path('auth/', include('server.auth.urls')),
]
