from rest_framework import serializers
from .models import User, UserProfile, Email, Attachment, Label, UserSettings
from django.contrib.auth.password_validation import validate_password
from rest_framework.exceptions import ValidationError
from django.core.validators import FileExtensionValidator
import magic
from django.contrib.auth import authenticate
from django.utils.translation import gettext_lazy as _
from django.db import transaction


class UserSerializer(serializers.ModelSerializer):
    profile_picture = serializers.SerializerMethodField()
    is_phone_verified = serializers.BooleanField(read_only=True)

    class Meta:
        model = User
        fields = [
            "id",
            "phone_number",
            "first_name",
            "last_name",
            "email",
            "profile_picture",
            "is_phone_verified",
        ]

    def get_profile_picture(self, obj):
        try:
            # Use a default image if no profile picture
            return (
                obj.profile.profile_picture.url
                if obj.profile.profile_picture
                else "/default-avatar.png"
            )
        except UserProfile.DoesNotExist:
            return "/default-avatar.png"


class UserProfileSerializer(serializers.ModelSerializer):
    user = serializers.PrimaryKeyRelatedField(read_only=True)
    profile_picture = serializers.ImageField(
        required=False,
        allow_null=True,
        validators=[
            FileExtensionValidator(["jpg", "jpeg", "png", "gif"]),
        ],
    )

    class Meta:
        model = UserProfile
        fields = [
            "id",
            "user",
            "profile_picture",
            "bio",
            "birthdate",
            "two_factor_enabled",
        ]

    def validate_profile_picture(self, value):
        # Additional file validation
        if value:
            # Check file size (10MB limit)
            if value.size > 10 * 1024 * 1024:
                raise serializers.ValidationError("Image size should not exceed 10MB.")

            # Validate mime type
            file_mime = magic.from_buffer(value.read(2048), mime=True)
            if not file_mime.startswith("image/"):
                raise serializers.ValidationError("Only image files are allowed.")
        return value


class UserRegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(
        write_only=True,
        required=True,
        validators=[validate_password],
        style={"input_type": "password"},
    )
    password2 = serializers.CharField(
        write_only=True, required=True, style={"input_type": "password"}
    )
    verification_code = serializers.CharField(write_only=True, required=False)
    phone_number = serializers.CharField(required=True)
    first_name = serializers.CharField(required=True)
    last_name = serializers.CharField(required=True)
    email = serializers.EmailField(required=True)

    class Meta:
        model = User
        fields = (
            "phone_number",
            "first_name",
            "last_name",
            "email",
            "password",
            "password2",
            "verification_code",
        )

    def validate(self, attrs):
        # Check for missing required fields
        required_fields = [
            "phone_number",
            "first_name",
            "last_name",
            "email",
            "password",
            "password2",
        ]
        missing_fields = [field for field in required_fields if field not in attrs]

        # Check if passwords match
        if attrs.get("password") != attrs.get("password2"):
            raise serializers.ValidationError(
                {"password": "Password fields didn't match."}
            )

        if missing_fields:
            raise serializers.ValidationError(
                {"detail": f"Missing required fields: {', '.join(missing_fields)}"}
            )

        # Optional phone verification logic
        if "verification_code" in attrs and attrs["verification_code"]:
            # Add phone verification logic here
            # For example, check against a stored verification code
            pass

        return attrs

    def create(self, validated_data):
        # Remove fields not needed for user creation
        validated_data.pop("password2", None)
        validated_data.pop("verification_code", None)

        # Create user with the provided details
        user = User.objects.create_user(
            username=validated_data[
                "phone_number"
            ],  # Assuming phone_number is used as username
            phone_number=validated_data["phone_number"],
            first_name=validated_data["first_name"],
            last_name=validated_data["last_name"],
            email=validated_data["email"],  # Save email
            password=validated_data["password"],
        )

        return user


class LoginSerializer(serializers.Serializer):
    phone_number = serializers.CharField(required=True)
    password = serializers.CharField(required=True, style={"input_type": "password"})

    def validate(self, attrs):
        phone_number = attrs.get("phone_number")
        password = attrs.get("password")

        if phone_number and password:
            user = authenticate(
                request=self.context.get("request"),
                username=phone_number,
                password=password,
            )

            if not user:
                msg = _("Unable to log in with provided credentials.")
                raise serializers.ValidationError(msg, code="authorization")

        else:
            msg = _('Must include "phone_number" and "password".')
            raise serializers.ValidationError(msg, code="authorization")

        attrs["user"] = user
        return attrs


class AutoReplySettingsSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserSettings
        fields = [
            "auto_reply_enabled",
            "auto_reply_message",
            "auto_reply_start_date",
            "auto_reply_end_date",
        ]
        extra_kwargs = {
            "auto_reply_message": {"required": False, "allow_blank": True},
            "auto_reply_from_email": {"required": False, "allow_blank": True},
        }

    def validate_auto_reply_message(self, value):
        max_length = 500  # Example max length
        if len(value) > max_length:
            raise serializers.ValidationError(
                f"Auto-reply message cannot exceed {max_length} characters."
            )
        return value

    def validate(self, data):
        # Ensure message is provided when enabling auto-reply
        if data.get("auto_reply_enabled", False) and not data.get("auto_reply_message"):
            raise serializers.ValidationError(
                {
                    "auto_reply_message": "Auto-reply message is required when auto-reply is enabled."
                }
            )

        return data

class FontSettingsSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserSettings
        fields = ['font_size', 'font_family']


class ChangePasswordSerializer(serializers.Serializer):
    old_password = serializers.CharField(
        required=True, style={"input_type": "password"}
    )
    new_password = serializers.CharField(
        required=True, validators=[validate_password], style={"input_type": "password"}
    )
    new_password2 = serializers.CharField(
        required=True, style={"input_type": "password"}
    )

    def validate(self, data):
        user = self.context["request"].user

        if not user.check_password(data["old_password"]):
            raise ValidationError({"old_password": "Incorrect current password."})

        if data["new_password"] != data["new_password2"]:
            raise ValidationError({"new_password": "New password fields didn't match."})

        return data


class AttachmentSerializer(serializers.ModelSerializer):
    file_url = serializers.SerializerMethodField()
    file_preview = serializers.SerializerMethodField()

    class Meta:
        model = Attachment
        fields = ["id", "file", "filename", "content_type", "file_url", "file_preview"]

    def get_file_url(self, obj):
        request = self.context.get("request")
        if request:
            return request.build_absolute_uri(obj.file.url)
        return None

    def get_file_preview(self, obj):
        # Implement preview logic for supported file types
        supported_preview_types = [
            "image/jpeg",
            "image/png",
            "image/gif",
            "application/pdf",
            "text/plain",
        ]
        if obj.content_type in supported_preview_types:
            # Generate or return preview URL/data
            return f"/preview/{obj.id}"
        return None


class LabelSerializer(serializers.ModelSerializer):
    # Add a count of emails associated with this label
    email_count = serializers.SerializerMethodField()

    class Meta:
        model = Label
        fields = ["id", "name", "color", "email_count"]  # Add email_count field

    def get_email_count(self, obj):
        return obj.emails.count()


class UserSettingsSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserSettings
        fields = [
            "notifications_enabled",
            "font_size",
            "font_family",
            "dark_mode",
            "auto_reply_enabled",
            "auto_reply_message",
            "signature",
            "auto_reply_from_email",
        ]


class EmailSerializer(serializers.ModelSerializer):
    sender = serializers.SlugRelatedField(slug_field="email", read_only=True)
    recipients = serializers.SlugRelatedField(
        slug_field="email", many=True, read_only=True
    )
    cc = serializers.SlugRelatedField(slug_field="email", many=True, read_only=True)
    bcc = serializers.SlugRelatedField(slug_field="email", many=True, read_only=True)
    attachments = AttachmentSerializer(many=True, read_only=True)
    labels = LabelSerializer(many=True, read_only=True)
    is_reply = serializers.SerializerMethodField()

    class Meta:
        model = Email
        fields = [
            "id",
            "sender",
            "recipients",
            "cc",
            "bcc",
            "subject",
            "body",
            "attachments",
            "sent_at",
            "is_read",
            "is_starred",
            "is_draft",
            "is_trashed",
            "reply_to",
            "headers",
            "labels",
            "is_reply",
        ]

    def get_is_reply(self, obj):
        return obj.reply_to is not None


class CreateEmailSerializer(serializers.ModelSerializer):
    recipients = serializers.ListField(child=serializers.EmailField(), write_only=True)
    cc = serializers.ListField(
        child=serializers.EmailField(), write_only=True, required=False
    )
    bcc = serializers.ListField(
        child=serializers.EmailField(), write_only=True, required=False
    )
    attachments = serializers.ListField(
        child=serializers.FileField(
            validators=[
                FileExtensionValidator(
                    [
                        "pdf",
                        "doc",
                        "docx",
                        "txt",
                        "jpg",
                        "jpeg",
                        "png",
                        "gif",
                        "xlsx",
                        "xls",
                    ]
                )
            ]
        ),
        required=False,
    )
    labels = serializers.PrimaryKeyRelatedField(
        queryset=Label.objects.all(), many=True, required=False
    )

    class Meta:
        model = Email
        fields = [
            "recipients",
            "cc",
            "bcc",
            "subject",
            "body",
            "attachments",
            "is_draft",
            "labels",
        ]

    def validate_attachments(self, value):
        # Additional attachment validation
        for attachment in value:
            # File size limit (10MB per file)
            if attachment.size > 10 * 1024 * 1024:
                raise serializers.ValidationError(
                    f"File {attachment.name} exceeds 10MB size limit."
                )
        return value

    def create(self, validated_data):
        with transaction.atomic():
            recipients_emails = validated_data.pop("recipients", [])
            cc_emails = validated_data.pop("cc", [])
            bcc_emails = validated_data.pop("bcc", [])
            attachments = validated_data.pop("attachments", [])
            labels = validated_data.pop("labels", [])

            # Get the currently authenticated user as the sender
            sender = self.context["request"].user

            # Convert email addresses to User instances
            recipients = User.objects.filter(email__in=recipients_emails)
            cc = User.objects.filter(email__in=cc_emails)
            bcc = User.objects.filter(email__in=bcc_emails)

            # Validate recipients
            if len(recipients) != len(recipients_emails):
                raise serializers.ValidationError(
                    {"recipients": "One or more recipient emails are invalid."}
                )
            if cc_emails and len(cc) != len(cc_emails):
                raise serializers.ValidationError(
                    {"cc": "One or more CC emails are invalid."}
                )
            if bcc_emails and len(bcc) != len(bcc_emails):
                raise serializers.ValidationError(
                    {"bcc": "One or more BCC emails are invalid."}
                )

            # Create email with the sender
            email = Email.objects.create(sender=sender, **validated_data)

            # Set recipients, cc, and bcc
            email.recipients.set(recipients)
            email.cc.set(cc)
            email.bcc.set(bcc)

            # Handle attachments
            if attachments:
                for attachment_data in attachments:
                    attachment = Attachment.objects.create(
                        file=attachment_data,
                        filename=attachment_data.name,
                        content_type=attachment_data.content_type,
                    )
                    email.attachments.add(attachment)

            # Set labels
            if labels:
                email.labels.set(labels)

        return email


class EmailDetailSerializer(
    EmailSerializer
):  # Inherit for detail view, adds reply info
    replies = serializers.SerializerMethodField()

    class Meta:
        model = Email
        fields = "__all__"  # or list specific fields, including 'replies'

    def get_replies(self, obj):
        # Serialize replies, possibly with a simplified serializer
        return EmailSerializer(obj.replies.all(), many=True, context=self.context).data
