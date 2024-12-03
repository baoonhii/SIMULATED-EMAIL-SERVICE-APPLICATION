import json
from asgiref.sync import async_to_sync
from channels.layers import get_channel_layer
from django.db.models.signals import m2m_changed
from django.dispatch import receiver
from django.utils import timezone
from .models import Email, Notification, UserSettings
from .serializers import EmailSerializer, NotificationSerializer


@receiver(m2m_changed, sender=Email.recipients.through)
def send_email_notification(sender, instance, action, **kwargs):
    if action == "post_add":
        print(instance)
        print("Signal triggered")

        channel_layer = get_channel_layer()

        # Determine recipients
        recipients = set()
        try:
            # Print detailed recipient information
            print("Recipients:", list(instance.recipients.all()))
            print("CC:", list(instance.cc.all()))
            print("BCC:", list(instance.bcc.all()))

            recipients.update(instance.recipients.all())
            recipients.update(instance.cc.all())
            recipients.update(instance.bcc.all())

            print("Total unique recipients:", len(recipients))
        except Exception as e:
            print(f"Error gathering email recipients: {e}")
            return

        # If no recipients, exit early
        if not recipients:
            print("No recipients found")
            return

        # Serialize email data using EmailSerializer
        email_data = EmailSerializer(instance).data

        print(email_data)

        # Send to each recipient's channel group
        for recipient in recipients:
            try:
                # Create Notification object
                notification = Notification.objects.create(
                    user=recipient,
                    message=f"You have a new email from {instance.sender.first_name} {instance.sender.last_name}!",
                    related_email=instance,
                    notification_type="email",
                )

                # Serialize notification data
                notification_data = NotificationSerializer(notification).data

                # Combine email and notification data
                message = {
                    "type": "email_notification",
                    "email": email_data,
                    "notification": notification_data,
                }
                group = f"user_{recipient.id}_emails"
                print(f"Sending to group: {group}")
                async_to_sync(channel_layer.group_send)(group, message)

                # Check for auto-reply
                handle_auto_reply(instance, recipient)
            except Exception as e:
                print(
                    f"Error sending WebSocket notification to user {recipient.id}: {e}"
                )


def handle_auto_reply(email: Email, recipient):
    print("handling auto reply")
    try:
        if not email.is_auto_replied:
            user_settings = UserSettings.objects.get(user=recipient)
            print("Found user")
            if user_settings.auto_reply_enabled:
                auto_reply_message = user_settings.auto_reply_message
                auto_reply_email = Email.objects.create(
                    sender=recipient,
                    subject=f"Re: {email.subject}",
                    body=plain_text_to_quill_delta(auto_reply_message),
                    sent_at=timezone.now(),
                    is_auto_replied=True,
                    reply_to=email,
                )
                # Set recipients using the set() method
                auto_reply_email.recipients.set([email.sender])
                auto_reply_email.save()  # Ensure the email is saved

                # Serialize auto-reply email data
                auto_reply_email_data = EmailSerializer(auto_reply_email).data

                # Create Notification object for auto-reply
                auto_reply_notification = Notification.objects.create(
                    user=email.sender,
                    message=f"You have received an auto-reply from {recipient.first_name} {recipient.last_name}.",
                    related_email=auto_reply_email,
                    notification_type="email",
                )

                # Serialize auto-reply notification data
                auto_reply_notification_data = NotificationSerializer(
                    auto_reply_notification
                ).data

                # Combine auto-reply email and notification data
                auto_reply_message = {
                    "type": "email_notification",
                    "email": auto_reply_email_data,
                    "notification": auto_reply_notification_data,
                }
                
                print()
                print()
                print()
                print()
                
                print(auto_reply_notification_data)
                
                print()
                print()
                print()
                print()
                
                group = f"user_{email.sender.id}_emails"
                print(f"Sending auto-reply to group: {group}")
                async_to_sync(get_channel_layer().group_send)(group, auto_reply_message)
    except UserSettings.DoesNotExist:
        print(f"No user settings found for user {recipient.id}")
    except Exception as e:
        print(f"Error handling auto-reply for user {recipient.id}: {e}")

def plain_text_to_quill_delta(text):
    # Convert plain text to Quill Delta format
    delta = f'[{{"insert": "{text}\\n"}}]'
    return delta