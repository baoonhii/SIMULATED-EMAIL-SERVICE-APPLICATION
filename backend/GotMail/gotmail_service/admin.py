from django.contrib import admin
from .models import User, Email, Label
# Register your models here.

admin.site.register(User)
admin.site.register(Email)
admin.site.register(Label)