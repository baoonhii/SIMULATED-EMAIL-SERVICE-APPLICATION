import json

from asgiref.sync import sync_to_async
from channels.generic.websocket import AsyncWebsocketConsumer
from django.contrib.auth import get_user_model
from django.utils import timezone


class EmailConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        self.token = self.scope["query_string"].decode("utf-8").split("=")[1]
        self.user = await self.get_user_from_token(self.token)
        # Only allow authenticated users
        if self.user:
            print("Got user")
            self.group_name = f"user_{self.user.id}_emails"
            print(f"Adding user to group: {self.group_name}")
            await self.channel_layer.group_add(self.group_name, self.channel_name)
            print(self.channel_layer)
            await self.accept()
        else:
            await self.close()

    async def disconnect(self, close_code):
        print(f"Removing user from group: {self.group_name}")
        await self.channel_layer.group_discard(self.group_name, self.channel_name)

    async def email_notification(self, event):
        # Send email notification to the client
        print(f"Sending email notification to client: {event}")
        await self.send(
            text_data=json.dumps({"type": event["type"], "email": event["email"], "notification": event["notification"]})
        )

    async def get_user_from_token(self, token):
        try:
            user = await sync_to_async(get_user_model().objects.get)(
                session_token=token, session_expiry__gt=timezone.now()
            )
            return user
        except get_user_model().DoesNotExist:
            return None
