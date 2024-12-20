# Generated by Django 5.1.1 on 2024-11-29 01:29

import django.contrib.auth.models
import django.core.validators
import django.db.models.deletion
import django.utils.timezone
import gotmail_service.models
import uuid
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):
    initial = True

    dependencies = [
        ("auth", "0012_alter_user_first_name_max_length"),
    ]

    operations = [
        migrations.CreateModel(
            name="Attachment",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                (
                    "file",
                    models.FileField(
                        upload_to="attachments/",
                        validators=[
                            gotmail_service.models.Attachment.validate_file_size
                        ],
                    ),
                ),
                ("filename", models.CharField(max_length=255)),
                (
                    "content_type",
                    models.CharField(blank=True, max_length=255, null=True),
                ),
            ],
        ),
        migrations.CreateModel(
            name="User",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("password", models.CharField(max_length=128, verbose_name="password")),
                (
                    "last_login",
                    models.DateTimeField(
                        blank=True, null=True, verbose_name="last login"
                    ),
                ),
                (
                    "is_superuser",
                    models.BooleanField(
                        default=False,
                        help_text="Designates that this user has all permissions without explicitly assigning them.",
                        verbose_name="superuser status",
                    ),
                ),
                (
                    "first_name",
                    models.CharField(
                        blank=True, max_length=150, verbose_name="first name"
                    ),
                ),
                (
                    "last_name",
                    models.CharField(
                        blank=True, max_length=150, verbose_name="last name"
                    ),
                ),
                (
                    "email",
                    models.EmailField(
                        blank=True, max_length=254, verbose_name="email address"
                    ),
                ),
                (
                    "is_staff",
                    models.BooleanField(
                        default=False,
                        help_text="Designates whether the user can log into this admin site.",
                        verbose_name="staff status",
                    ),
                ),
                (
                    "is_active",
                    models.BooleanField(
                        default=True,
                        help_text="Designates whether this user should be treated as active. Unselect this instead of deleting accounts.",
                        verbose_name="active",
                    ),
                ),
                (
                    "date_joined",
                    models.DateTimeField(
                        default=django.utils.timezone.now, verbose_name="date joined"
                    ),
                ),
                (
                    "phone_number",
                    models.CharField(
                        max_length=20,
                        unique=True,
                        validators=[
                            django.core.validators.RegexValidator(
                                message="Phone number must be entered in the format: '+999999999'. Up to 15 digits allowed.",
                                regex="^\\+?1?\\d{9,15}$",
                            )
                        ],
                    ),
                ),
                ("is_phone_verified", models.BooleanField(default=False)),
                (
                    "session_token",
                    models.CharField(blank=True, max_length=255, null=True),
                ),
                ("session_expiry", models.DateTimeField(blank=True, null=True)),
                (
                    "username",
                    models.CharField(
                        blank=True, max_length=150, null=True, unique=True
                    ),
                ),
                (
                    "groups",
                    models.ManyToManyField(
                        blank=True, related_name="gotmail_user_set", to="auth.group"
                    ),
                ),
                (
                    "user_permissions",
                    models.ManyToManyField(
                        blank=True,
                        related_name="gotmail_user_set",
                        to="auth.permission",
                    ),
                ),
            ],
            options={
                "verbose_name": "user",
                "verbose_name_plural": "users",
                "abstract": False,
            },
            managers=[
                ("objects", django.contrib.auth.models.UserManager()),
            ],
        ),
        migrations.CreateModel(
            name="Email",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                (
                    "message_id",
                    models.UUIDField(default=uuid.uuid4, editable=False, unique=True),
                ),
                ("subject", models.CharField(max_length=255)),
                ("body", models.TextField()),
                ("sent_at", models.DateTimeField(default=django.utils.timezone.now)),
                ("is_read", models.BooleanField(default=False)),
                ("is_starred", models.BooleanField(default=False)),
                ("is_draft", models.BooleanField(default=False)),
                ("is_trashed", models.BooleanField(default=False)),
                ("is_auto_replied", models.BooleanField(default=False)),
                ("headers", models.JSONField(blank=True, null=True)),
                (
                    "status",
                    models.CharField(
                        choices=[
                            ("unread", "Unread"),
                            ("read", "Read"),
                            ("replied", "Replied"),
                            ("forwarded", "Forwarded"),
                        ],
                        default="unread",
                        max_length=20,
                    ),
                ),
                (
                    "attachments",
                    models.ManyToManyField(blank=True, to="gotmail_service.attachment"),
                ),
                (
                    "bcc",
                    models.ManyToManyField(
                        blank=True,
                        related_name="emails_bcc",
                        to=settings.AUTH_USER_MODEL,
                    ),
                ),
                (
                    "cc",
                    models.ManyToManyField(
                        blank=True,
                        related_name="emails_cc",
                        to=settings.AUTH_USER_MODEL,
                    ),
                ),
                (
                    "recipients",
                    models.ManyToManyField(
                        blank=True,
                        related_name="emails_received",
                        to=settings.AUTH_USER_MODEL,
                    ),
                ),
                (
                    "reply_to",
                    models.ForeignKey(
                        blank=True,
                        null=True,
                        on_delete=django.db.models.deletion.SET_NULL,
                        related_name="replies",
                        to="gotmail_service.email",
                    ),
                ),
                (
                    "sender",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="emails_sent",
                        to=settings.AUTH_USER_MODEL,
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="UserProfile",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                (
                    "profile_picture",
                    models.ImageField(
                        blank=True, null=True, upload_to="profile_pictures/"
                    ),
                ),
                ("bio", models.TextField(blank=True)),
                ("birthdate", models.DateField(blank=True, null=True)),
                ("two_factor_enabled", models.BooleanField(default=False)),
                (
                    "two_factor_secret",
                    models.CharField(blank=True, max_length=255, null=True),
                ),
                (
                    "password_reset_token",
                    models.CharField(blank=True, max_length=255, null=True),
                ),
                ("password_reset_expires", models.DateTimeField(blank=True, null=True)),
                (
                    "user",
                    models.OneToOneField(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="profile",
                        to=settings.AUTH_USER_MODEL,
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="UserSettings",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("notifications_enabled", models.BooleanField(default=True)),
                (
                    "font_size",
                    models.IntegerField(
                        choices=[(12, "Small"), (14, "Medium"), (16, "Large")],
                        default=14,
                    ),
                ),
                (
                    "font_family",
                    models.CharField(
                        choices=[
                            ("sans-serif", "Sans-serif"),
                            ("serif", "Serif"),
                            ("monospace", "Monospace"),
                        ],
                        default="sans-serif",
                        max_length=50,
                    ),
                ),
                ("dark_mode", models.BooleanField(default=False)),
                ("auto_reply_enabled", models.BooleanField(default=False)),
                ("auto_reply_message", models.TextField(blank=True, null=True)),
                ("signature", models.TextField(blank=True, null=True)),
                (
                    "auto_reply_from_email",
                    models.EmailField(blank=True, max_length=254, null=True),
                ),
                ("auto_reply_start_date", models.DateTimeField(blank=True, null=True)),
                ("auto_reply_end_date", models.DateTimeField(blank=True, null=True)),
                ("notification_email", models.BooleanField(default=True)),
                ("notification_push", models.BooleanField(default=True)),
                (
                    "user",
                    models.OneToOneField(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="settings",
                        to=settings.AUTH_USER_MODEL,
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="Label",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("name", models.CharField(max_length=50)),
                (
                    "color",
                    models.CharField(blank=True, default="#808080", max_length=7),
                ),
                (
                    "emails",
                    models.ManyToManyField(
                        blank=True, related_name="labels", to="gotmail_service.email"
                    ),
                ),
                (
                    "user",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="labels",
                        to=settings.AUTH_USER_MODEL,
                    ),
                ),
            ],
            options={
                "unique_together": {("user", "name")},
            },
        ),
    ]
