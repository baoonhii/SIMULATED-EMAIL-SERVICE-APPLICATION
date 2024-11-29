import json
import logging
from channels.generic.websocket import AsyncWebsocketConsumer
from channels.db import database_sync_to_async
from django.core.exceptions import PermissionDenied
from asgiref.sync import sync_to_async

from .models import User, Email, UserSettings
from .serializers import EmailSerializer

logger = logging.getLogger(__name__)

class EmailNotificationConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        """
        Handle WebSocket connection:
        1. Authenticate user
        2. Add user to a group for personal notifications
        3. Send initial unread email count and notification settings
        """
        user = self.scope['user']
        if not user.is_authenticated:
            await self.close()
            return

        try:
            # Get user settings to determine notification preferences
            user_settings = await self.get_user_settings(user)

            # Add user to their personal notification group
            self.user_id = user.id
            await self.channel_layer.group_add(f"user_{self.user_id}", self.channel_name)
            await self.accept()

            # Send initial connection data
            await self.send(text_data=json.dumps({
                'type': 'connection_data',
                'unread_count': await self.get_unread_email_count(user),
                'notifications_enabled': user_settings.notifications_enabled,
                'notification_push': user_settings.notification_push,
                'notification_sound': user_settings.notification_sound
            }))

        except Exception as e:
            logger.error(f"Connection error: {str(e)}")
            await self.close()

    async def disconnect(self, close_code):
        """
        Remove user from the notification group when disconnecting
        """
        if hasattr(self, 'user_id'):
            await self.channel_layer.group_discard(f"user_{self.user_id}", self.channel_name)

    async def receive(self, text_data):
        """
        Handle incoming WebSocket messages:
        1. Mark emails as read
        2. Update notification preferences
        """
        try:
            data = json.loads(text_data)
            user = self.scope['user']

            if data['type'] == 'mark_as_read':
                await self.handle_mark_as_read(user, data)
            
            elif data['type'] == 'update_notification_settings':
                await self.update_notification_settings(user, data)

        except Exception as e:
            logger.error(f"WebSocket receive error: {str(e)}")
            await self.send(text_data=json.dumps({
                'type': 'error',
                'message': 'An error occurred processing your request'
            }))

    async def handle_mark_as_read(self, user, data):
        """
        Handle marking specific emails or all emails as read
        """
        email_id = data.get('email_id')
        mark_all = data.get('mark_all', False)

        if mark_all:
            await self.mark_all_emails_as_read(user)
        elif email_id:
            await self.mark_single_email_as_read(user, email_id)

        # Update unread count after marking
        unread_count = await self.get_unread_email_count(user)
        await self.send(text_data=json.dumps({
            'type': 'unread_count', 
            'count': unread_count
        }))

    async def new_email(self, event):
        """
        Handle incoming new email notifications
        Send details to the client and update unread count
        """
        user = self.scope['user']
        user_settings = await self.get_user_settings(user)

        # Only send if notifications are enabled
        if user_settings.notifications_enabled:
            email_data = event['message']
            
            # Send email notification
            await self.send(text_data=json.dumps({
                'type': 'new_email',
                'email': email_data,
                'notification_push': user_settings.notification_push,
                'notification_sound': user_settings.notification_sound
            }))

            # Update unread count
            unread_count = await self.get_unread_email_count(user)
            await self.send(text_data=json.dumps({
                'type': 'unread_count', 
                'count': unread_count
            }))

    async def update_notification_settings(self, user, data):
        """
        Update user notification preferences
        """
        settings = await self.get_user_settings(user)
        
        # Update settings based on received data
        settings.notifications_enabled = data.get('notifications_enabled', settings.notifications_enabled)
        settings.notification_push = data.get('notification_push', settings.notification_push)
        settings.notification_sound = data.get('notification_sound', settings.notification_sound)
        
        await self.save_user_settings(settings)
        
        await self.send(text_data=json.dumps({
            'type': 'settings_updated',
            'message': 'Notification settings updated successfully'
        }))

    @database_sync_to_async
    def get_user_settings(self, user):
        """
        Retrieve user settings, creating them if they don't exist
        """
        settings, _ = UserSettings.objects.get_or_create(user=user)
        return settings

    @database_sync_to_async
    def save_user_settings(self, settings):
        """
        Save updated user settings
        """
        settings.save()

    @database_sync_to_async
    def get_unread_email_count(self, user):
        """
        Get the count of unread emails for a user
        """
        return Email.objects.filter(recipients=user, is_read=False).count()

    @database_sync_to_async
    def mark_single_email_as_read(self, user, email_id):
        """
        Mark a single email as read
        """
        try:
            email = Email.objects.get(pk=email_id, recipients=user)
            email.is_read = True
            email.save()
        except Email.DoesNotExist:
            logger.warning(f"Attempt to mark non-existent email {email_id} as read")

    @database_sync_to_async
    def mark_all_emails_as_read(self, user):
        """
        Mark all unread emails as read for a user
        """
        Email.objects.filter(recipients=user, is_read=False).update(is_read=True)