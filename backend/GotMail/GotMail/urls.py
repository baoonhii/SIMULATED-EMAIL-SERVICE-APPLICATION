"""
URL configuration for GotMail project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from django.contrib.auth import views as auth_views

from gotmail_service.views import LogoutView, RegisterView, LoginView, UserProfileView, SendEmailView, ValidateTokenView

urlpatterns = [
    path("admin/", admin.site.urls),
    path('accounts/login/', auth_views.LoginView.as_view(), name='login'),
    # API END POINTS
    path('auth/register/', RegisterView.as_view(), name="api_register"),
    path('auth/login/', LoginView.as_view(), name="api_login"),
    path('auth/logout/', LogoutView.as_view(), name="api_logout"),
    path('auth/validate_token/', ValidateTokenView.as_view(), name="validate_token"),
    path('auth/profile/', UserProfileView.as_view(), name="api_profile"),
    path('email/send/', SendEmailView.as_view(), name="api_send_mail"),
]
