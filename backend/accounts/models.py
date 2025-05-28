from django.db import models
from django.contrib.auth.models import User
from django.dispatch import receiver
from django.utils.safestring import mark_safe
from django.db.models.signals import post_save, post_delete
from django.utils.text import slugify
# rest frame work token imports 
from django.conf import settings
from rest_framework.authtoken.models import Token

def image_upload(instance,filename:str):
    extension=filename.split('.')[1]
    return f"{(instance._meta.verbose_name).lower()}/{instance.__str__()}.{extension}"

def cover_upload(instance,filename:str):
    extension=filename.split('.')[1]
    return f"cover/{instance.__str__()}.{extension}"

# Create your models here.
class Profile(models.Model):

    user = models.ForeignKey(User, verbose_name=("User"), on_delete=models.CASCADE)
    tagline = models.CharField(("Tagline"), max_length=50, null=True, blank=True)
    organization = models.CharField(("Organization"), max_length=50, null=True, blank=True)
    rank = models.CharField(("Rank"), max_length=50, default="Bornze")
    interested = models.IntegerField(("Interested"), default=0, null=True, blank=True)
    interesting = models.IntegerField(("Interesting"), default=0, null=True, blank=True)
    image = models.ImageField(verbose_name=("Profile Image"), upload_to=image_upload, height_field=None, width_field=None, max_length=None, null=True, blank=True)
    cover = models.ImageField(verbose_name=("Profile Cover"), upload_to=cover_upload, height_field=None, width_field=None, max_length=None, null=True, blank=True)
    views = models.IntegerField(("Profile Views"), default=0, null=True, blank=True)
    discussions_count = models.IntegerField(("Discussions Count"), default=0, null=True, blank=True)
    discussions_interacted_with = models.IntegerField(("Discussions Interacted With"), default=0, null=True, blank=True)
    
    @property
    def full_name(self):
        return f"{self.user.first_name} {self.user.last_name}"
    
    @property
    def user_id(self):
        return self.user.id
    
    class Meta:
        verbose_name = ("Profile")
        verbose_name_plural = ("Profiles")

    def __str__(self):
        return self.user.username
    
# signal to create auth token automatically in api
@receiver(post_save, sender=settings.AUTH_USER_MODEL)
def create_auth_token(sender, instance=None, created=False, **kwargs):
    if created:
        Token.objects.create(user=instance)

class Interest(models.Model):

    sender = models.ForeignKey(Profile, verbose_name=("Profile"), related_name='sender_profile', on_delete=models.CASCADE)
    receiver = models.ForeignKey(Profile, verbose_name=("Profile"), related_name='receiver_profile', on_delete=models.CASCADE)

    class Meta:
        verbose_name = ("Interest")
        verbose_name_plural = ("Interests")

    def __str__(self):
        return self.name
