from django.contrib import admin
from .models import Forum, Discussion, Comment

# Register your models here.
admin.site.register(Forum)
admin.site.register(Discussion)
admin.site.register(Comment)