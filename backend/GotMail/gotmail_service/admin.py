from django.contrib import admin

from .models import Email, Label, Notification, User, UserProfile, UserSettings

# Register your models here.

admin.site.register(User)
admin.site.register(Email)
admin.site.register(Label)
admin.site.register(Notification)
admin.site.register(UserProfile)
admin.site.register(UserSettings)
