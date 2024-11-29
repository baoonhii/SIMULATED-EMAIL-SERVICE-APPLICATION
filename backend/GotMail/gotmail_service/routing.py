from django.urls import re_path
from . import consumers  # Adjust import path if necessary

websocket_urlpatterns = [
    re_path(r'ws/notifications/$', consumers.EmailNotificationConsumer.as_asgi()),
]
