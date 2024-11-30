from django.contrib.auth import login, logout
from django.core.exceptions import ValidationError
from django.core.validators import validate_email
from django.db.models import Q
from django.shortcuts import get_object_or_404
from django.utils import timezone
from rest_framework import filters, generics, permissions, serializers, status
from rest_framework.authentication import BaseAuthentication
from rest_framework.exceptions import AuthenticationFailed
from rest_framework.parsers import FormParser, MultiPartParser
from rest_framework.response import Response
from rest_framework.views import APIView

from .models import Attachment, Email, Label, User, UserProfile, UserSettings
from .serializers import (
    AttachmentSerializer,
    AutoReplySettingsSerializer,
    ChangePasswordSerializer,
    CreateEmailSerializer,
    EmailDetailSerializer,
    EmailSerializer,
    FontSettingsSerializer,
    LabelSerializer,
    LoginSerializer,
    UserProfileSerializer,
    UserRegisterSerializer,
    UserSerializer,
    UserSettingsSerializer,
)


class SessionTokenAuthentication(BaseAuthentication):
    def authenticate(self, request):
        session_token = request.headers.get("Authorization")
        if not session_token:
            return None

        try:
            user = User.objects.get(
                session_token=session_token, session_expiry__gt=timezone.now()
            )
            return (user, None)
        except User.DoesNotExist:
            raise AuthenticationFailed("Invalid or expired token")


class BaseUserSettingsView(APIView):
    """
    Base class for handling user settings with common authentication and error handling.
    """

    authentication_classes = [SessionTokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]

    def get_or_create_user_settings(self) -> UserSettings:
        """
        Get or create UserSettings for the authenticated user.

        Returns:
            UserSettings: User settings object
        """
        return UserSettings.objects.get_or_create(user=self.request.user)[0]

    def handle_settings_update(
        self, serializer_class: serializers.ModelSerializer, data, partial: bool = True
    ) -> Response:
        """
        Generic method to update user settings with error handling.

        Args:
            serializer_class: Serializer to use for validation
            data: Data to update
            partial: Whether to allow partial updates

        Returns:
            Response with updated settings or error
        """
        try:
            user_settings = self.get_or_create_user_settings()
            serializer = serializer_class(user_settings, data=data, partial=partial)

            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data)

            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        except Exception as e:
            return Response(
                {"error": "Unable to update settings", "details": str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )


# Authentication Views
class RegisterView(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        print("Raw Registration Data:", request.data)

        serializer = UserRegisterSerializer(data=request.data)

        try:
            # Use is_valid with raise_exception=True to get detailed validation errors
            if serializer.is_valid(raise_exception=True):
                try:
                    # Create user
                    user = serializer.save()

                    # Additional post-registration actions
                    UserProfile.objects.create(user=user)
                    UserSettings.objects.create(user=user)

                    # Create default labels
                    default_labels = [
                        {"name": "Important", "color": "#FF0000"},
                        {"name": "Personal", "color": "#00FF00"},
                        {"name": "Work", "color": "#0000FF"},
                    ]
                    for label_data in default_labels:
                        Label.objects.create(user=user, **label_data)

                    # Log in the user
                    login(request, user)

                    return Response(
                        UserSerializer(user).data, status=status.HTTP_201_CREATED
                    )

                except Exception as e:
                    print(f"User Creation Error: {e}")
                    return Response(
                        {"error": str(e)}, status=status.HTTP_400_BAD_REQUEST
                    )

        except serializers.ValidationError as e:
            print(f"Validation Error: {e}")
            return Response(e.detail, status=status.HTTP_400_BAD_REQUEST)


class LoginView(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        serializer = LoginSerializer(data=request.data, context={"request": request})
        if serializer.is_valid():
            user = serializer.validated_data["user"]

            user.generate_session_token()

            login(request, user)

            return Response(
                {
                    "user": UserSerializer(user).data,
                    "session_token": user.session_token,
                },
                status=status.HTTP_200_OK,
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class LogoutView(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        try:
            # Try to get the session token from the request
            session_token = request.data.get("session_token") or request.headers.get(
                "Authorization"
            )

            # If token is provided, try to find and invalidate the user's session
            if session_token:
                try:
                    user = User.objects.get(
                        session_token=session_token, session_expiry__gt=timezone.now()
                    )
                    user.session_token = None
                    user.session_expiry = None
                    user.save()
                except User.DoesNotExist:
                    # Token not found or expired, but we'll still proceed with logout
                    pass

            # Perform Django logout
            logout(request)

            return Response(
                {"message": "Successfully logged out."}, status=status.HTTP_200_OK
            )

        except Exception as e:
            return Response(
                {"message": f"Logout failed: {str(e)}"},
                status=status.HTTP_400_BAD_REQUEST,
            )


class ValidateTokenView(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        session_token = request.data.get("session_token")
        try:
            user = User.objects.get(
                session_token=session_token, session_expiry__gt=timezone.now()
            )
            return Response(
                {"user": UserSerializer(user).data, "message": "Token is valid"},
                status=status.HTTP_200_OK,
            )
        except User.DoesNotExist:
            return Response(
                {"message": "Invalid or expired token"},
                status=status.HTTP_401_UNAUTHORIZED,
            )


class UserProfileView(generics.RetrieveUpdateDestroyAPIView):
    queryset = UserProfile.objects.all()
    serializer_class = UserProfileSerializer
    authentication_classes = [SessionTokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    parser_classes = [MultiPartParser, FormParser]

    def get_object(self):
        # Override get_object to return the profile of the authenticated user
        return get_object_or_404(UserProfile, user=self.request.user)

    def update(self, request, *args, **kwargs):
        partial = kwargs.pop("partial", False)
        instance = self.get_object()

        # Allow updating user details along with profile
        user_data = {
            "first_name": request.data.get("first_name"),
            "last_name": request.data.get("last_name"),
            "email": request.data.get("email"),
        }

        # Remove None values
        user_data = {k: v for k, v in user_data.items() if v is not None}

        if user_data:
            user_serializer = UserSerializer(request.user, data=user_data, partial=True)
            user_serializer.is_valid(raise_exception=True)
            user_serializer.save()

        # Prepare profile data
        profile_data = {
            "bio": request.data.get("bio"),
            "birthdate": request.data.get("birthdate"),
        }

        # Handle profile picture separately
        if "profile_picture" in request.FILES:
            profile_data["profile_picture"] = request.FILES["profile_picture"]

        # Remove None values
        profile_data = {k: v for k, v in profile_data.items() if v is not None}

        serializer = self.get_serializer(instance, data=profile_data, partial=partial)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)

        return Response(
            {"user": UserSerializer(request.user).data, "profile": serializer.data}
        )


class AutoReplySettingsView(BaseUserSettingsView):
    def get(self, request):
        """Retrieve current auto-reply settings"""
        user_settings = self.get_or_create_user_settings()
        serializer = AutoReplySettingsSerializer(user_settings)
        return Response(serializer.data)

    def put(self, request):
        """Update auto-reply settings"""
        return self.handle_settings_update(AutoReplySettingsSerializer, request.data)

    def patch(self, request):
        """Toggle auto-reply on/off"""
        try:
            user_settings = self.get_or_create_user_settings()
            user_settings.auto_reply_enabled = not user_settings.auto_reply_enabled

            # Set default dates if enabling
            if user_settings.auto_reply_enabled:
                user_settings.auto_reply_start_date = (
                    user_settings.auto_reply_start_date or timezone.now()
                )
                user_settings.auto_reply_end_date = (
                    user_settings.auto_reply_end_date
                    or timezone.now() + timezone.timedelta(days=30)
                )

            user_settings.save()
            serializer = AutoReplySettingsSerializer(user_settings)
            return Response(serializer.data)

        except Exception as e:
            return Response(
                {"error": "Unable to toggle auto-reply", "details": str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )


class FontSettingsView(BaseUserSettingsView):
    def get(self, request):
        """Retrieve current font settings"""
        user_settings = self.get_or_create_user_settings()
        serializer = FontSettingsSerializer(user_settings)
        return Response(serializer.data)

    def put(self, request):
        """Update font settings"""
        return self.handle_settings_update(FontSettingsSerializer, request.data)


class DarkModeToggleView(BaseUserSettingsView):
    def get(self, request):
        """Retrieve current dark mode setting"""
        user_settings = self.get_or_create_user_settings()
        return Response({"dark_mode": user_settings.dark_mode})

    def patch(self, request):
        """Set dark mode setting"""
        dark_mode = request.data.get("dark_mode")

        if dark_mode is None:
            return Response(
                {"error": "dark_mode field is required"},
                status=status.HTTP_400_BAD_REQUEST,
            )

        user_settings = self.get_or_create_user_settings()
        user_settings.dark_mode = dark_mode
        user_settings.save()

        return Response({"dark_mode": user_settings.dark_mode})


class SendEmailView(generics.CreateAPIView):
    """
    API endpoint for sending emails
    """

    serializer_class = CreateEmailSerializer
    authentication_classes = [SessionTokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]

    def create(self, request, *args, **kwargs):
        """
        Handle email creation and send
        """
        print(request.data)
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        # Create the email
        email = serializer.save()

        # Serialize the response using the full email serializer
        response_serializer = EmailSerializer(email, context={"request": request})

        return Response(response_serializer.data, status=status.HTTP_201_CREATED)


class EmailListView(generics.ListAPIView):
    """
    API endpoint for listing emails in different mailboxes
    """

    serializer_class = EmailSerializer
    authentication_classes = [SessionTokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        """
        Retrieve emails based on mailbox type
        """
        user = self.request.user
        mailbox = self.request.query_params.get("mailbox", "inbox")  # Use query_params

        if mailbox == "inbox":
            # Emails received by the user (recipients, cc, bcc)
            return (
                Email.objects.filter(Q(recipients=user) | Q(cc=user) | Q(bcc=user))
                .exclude(is_trashed=True)
                .order_by("-sent_at")
            )

        elif mailbox == "sent":
            # Emails sent by the user
            print("Fetching emails")
            print(Email.objects.count())
            print(Email.objects.filter(sender=user))
            return (
                Email.objects.filter(sender=user)
                .exclude(is_trashed=True)
                .order_by("-sent_at")
            )

        elif mailbox == "draft":
            # Drafts created by the user
            return Email.objects.filter(sender=user, is_draft=True).order_by("-sent_at")

        elif mailbox == "trash":
            # Trashed emails
            return Email.objects.filter(
                Q(sender=user) | Q(recipients=user) | Q(cc=user) | Q(bcc=user),
                is_trashed=True,
            ).order_by("-sent_at")


# Advanced Email Views
class AdvancedEmailSearchView(generics.ListAPIView):
    serializer_class = EmailSerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [filters.SearchFilter]
    search_fields = ["subject", "body", "sender__phone_number"]

    def get_queryset(self):
        user = self.request.user
        queryset = Email.objects.filter(Q(recipients=user) | Q(sender=user)).exclude(
            is_trashed=True
        )

        # Advanced filtering
        params = self.request.query_params

        # Filter by date range
        start_date = params.get("start_date")
        end_date = params.get("end_date")
        if start_date and end_date:
            queryset = queryset.filter(sent_at__range=[start_date, end_date])

        # Filter by status
        status = params.get("status")
        if status:
            if status == "unread":
                queryset = queryset.filter(is_read=False)
            elif status == "starred":
                queryset = queryset.filter(is_starred=True)

        # Filter by label
        label = params.get("label")
        if label:
            queryset = queryset.filter(labels__name=label)

        # Filter by attachments
        has_attachments = params.get("has_attachments")
        if has_attachments:
            queryset = queryset.filter(attachments__isnull=False).distinct()

        return queryset


# Utility Functions
def validate_phone_number(phone_number):
    """
    Basic phone number validation
    You might want to use a more robust library like phonenumbers
    """
    if not phone_number or len(phone_number) < 10 or len(phone_number) > 15:
        raise ValidationError("Invalid phone number")


def generate_session_token():
    """Generate a unique session token"""
    import uuid

    return str(uuid.uuid4())


# Two-Factor Authentication Setup View
class TwoFactorSetupView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        profile = request.user.profile

        # Generate and send verification code
        verification_code = generate_verification_code()

        # In a real app, you'd send this via SMS
        # For now, we'll just return the code (REMOVE IN PRODUCTION)
        return Response(
            {
                "message": "Verification code generated",
                "verification_code": verification_code,  # REMOVE IN PRODUCTION
            }
        )

    def put(self, request):
        profile = request.user.profile
        code = request.data.get("verification_code")

        # Verify the code (you'd implement actual verification logic)
        if verify_two_factor_code(code):
            profile.two_factor_enabled = True
            profile.save()
            return Response({"message": "Two-factor authentication enabled"})

        return Response(
            {"error": "Invalid verification code"}, status=status.HTTP_400_BAD_REQUEST
        )


# Placeholder functions - replace with actual implementation
def generate_verification_code():
    import random

    return str(random.randint(100000, 999999))


def verify_two_factor_code(code):
    # Implement actual verification logic
    return len(code) == 6 and code.isdigit()
