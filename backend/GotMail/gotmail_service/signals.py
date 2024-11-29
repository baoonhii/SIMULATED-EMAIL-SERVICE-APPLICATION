from django.db.models.signals import post_save, pre_save, m2m_changed
from django.dispatch import receiver
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync
from django.utils import timezone

from .models import Email, User, UserProfile, UserSettings, Label
from .serializers import EmailSerializer, UserProfileSerializer

@receiver(pre_save, sender=UserProfile)
def update_profile_picture(sender, instance, **kwargs):
    """
    Send notification when user profile picture is updated
    """
    try:
        old_profile = UserProfile.objects.get(pk=instance.pk)
        
        # Check if profile picture has changed
        if (instance.profile_picture and 
            instance.profile_picture != old_profile.profile_picture):
            
            channel_layer = get_channel_layer()
            
            # Prepare profile data
            profile_data = UserProfileSerializer(instance).data
            
            # Send updated profile picture to user's group
            async_to_sync(channel_layer.group_send)(
                f"user_{instance.user.id}",
                {
                    "type": "profile_picture_updated",
                    "profile_data": profile_data
                }
            )
    except UserProfile.DoesNotExist:
        return  # No existing profile to compare

@receiver(post_save, sender=Email)
def notify_new_email(sender, instance, created, **kwargs):
    """
    Notify recipients of a new email and handle auto-reply
    """
    if created and not instance.is_draft:
        # Get all recipients (including CC and BCC)
        recipient_ids = set(
            list(instance.recipients.values_list("id", flat=True)) +
            list(instance.cc.values_list("id", flat=True)) +
            list(instance.bcc.values_list("id", flat=True))
        )
        
        # Serialize the email
        serialized_email = EmailSerializer(instance, context={"request": None}).data
        
        channel_layer = get_channel_layer()
        
        # Send notification to each recipient
        for recipient_id in recipient_ids:
            async_to_sync(channel_layer.group_send)(
                f"user_{recipient_id}", 
                {
                    "type": "new_email",
                    "message": serialized_email
                }
            )
            
            # Check for auto-reply
            try:
                user_settings = UserSettings.objects.get(user_id=recipient_id)
                
                if (user_settings.auto_reply_enabled and 
                    user_settings.auto_reply_message):
                    # Create and send auto-reply
                    auto_reply = Email.objects.create(
                        sender=User.objects.get(id=recipient_id),
                        recipients=[instance.sender],
                        subject=f"Auto-Reply: {instance.subject}",
                        body=user_settings.auto_reply_message,
                        reply_to=instance,
                        is_auto_replied=True
                    )
            except (UserSettings.DoesNotExist, User.DoesNotExist):
                pass

@receiver(m2m_changed, sender=Email.labels.through)
def update_label_email_count(sender, instance, action, **kwargs):
    """
    Update label email count when labels are added or removed
    """
    if action in ["post_add", "post_remove"]:
        for label in instance.labels.all():
            label.save()  # Trigger any label-specific logic

@receiver(post_save, sender=Label)
def notify_label_update(sender, instance, created, **kwargs):
    """
    Notify user about label creation or modification
    """
    if created:
        channel_layer = get_channel_layer()
        async_to_sync(channel_layer.group_send)(
            f"user_{instance.user.id}",
            {
                "type": "label_created",
                "label_name": instance.name,
                "label_color": instance.color
            }
        )