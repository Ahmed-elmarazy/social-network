from django.db import models
from accounts.models import Profile

# Create your models here.
def image_upload(instance,filename:str):
    extension=filename.split('.')[1]
    return f"{(instance._meta.verbose_name).lower()}/{instance.__str__()}.{extension}"

class Forum(models.Model):

    profile = models.ForeignKey(Profile, related_name='forum_owner', on_delete=models.CASCADE , null=True, blank=True)
    members = models.ManyToManyField(Profile, related_name='forum_members', null=True, blank=True)
    cover = models.ImageField(("Forum Cover"), upload_to=image_upload, height_field=None, width_field=None, max_length=None, null=True, blank=True)
    title = models.CharField(("Title"), max_length=50)
    created_on = models.DateField(("Creation Date"), auto_now=True, auto_now_add=False)
    description = models.CharField(("Description"), max_length=50)
    members_count = models.IntegerField(("Members Count"), default=0, null=True, blank=True)
    
    class Meta:
        verbose_name = ("Forum")
        verbose_name_plural = ("Forums")

    def __str__(self):
        return self.title

class Discussion(models.Model):

    profile = models.ForeignKey(Profile, related_name='discussion_owner', on_delete=models.CASCADE , null=True, blank=True)
    forum = models.ForeignKey('Forum', related_name='discussions', on_delete=models.CASCADE, null=True, blank=True)
    interested = models.ManyToManyField(Profile, related_name='interested_profiles', null=True, blank=True)
    description = models.CharField(("Description"), max_length=50)
    created_on = models.DateField(("Creation Date"), auto_now=True, auto_now_add=False)
    interested_count = models.IntegerField(("Interested Count"), default=0, null=True, blank=True)
    comments_count = models.IntegerField(("Comments Count"), default=0, null=True, blank=True)
    
    class Meta:
        verbose_name = ("Discussion")
        verbose_name_plural = ("Discussions")
        
    def save_model(self, request, obj, form, change):
        self.interested_count = self.interested.count()
        super().save_model(request, obj,form,change)

    def __str__(self):
        return f"{self.profile}-{self.pk}-discussion"

class Comment(models.Model):

    profile = models.ForeignKey(Profile, related_name='comment_owner', on_delete=models.CASCADE , null=True, blank=True)
    discussion = models.ForeignKey(Discussion, related_name='comments', on_delete=models.CASCADE)
    description = models.CharField(("Description"), max_length=50)
    created_on = models.DateField(("Creation Date"), auto_now=True, auto_now_add=False)
    ups = models.IntegerField(("Ups"), default=0, null=True, blank=True)
    downs = models.IntegerField(("Downs"), default=0, null=True, blank=True)
    uppers = models.ManyToManyField(Profile, related_name='comment_uppers')
    downers = models.ManyToManyField(Profile, related_name='comment_downers')
    
    class Meta:
        verbose_name = ("Comment")
        verbose_name_plural = ("Comments")
        
    def save(self, *args, **kwargs):
        if self.id:
            self.ups = self.uppers.count()
            self.downs = self.downers.count()
        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.profile}-{self.id}-comment"
    