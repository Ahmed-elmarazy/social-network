from rest_framework import serializers   
from .models import Forum, Discussion, Comment
from accounts.serializer import *

class MinimalProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = ['id', 'user_id', 'full_name', 'tagline', 'organization', 'image']

class CommentSerializer(serializers.ModelSerializer):
    profile = MinimalProfileSerializer()
    uppers = MinimalProfileSerializer(many=True)
    downers = MinimalProfileSerializer(many=True)

    class Meta:
        model = Comment
        fields = '__all__'

class CommentCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Comment
        fields = ['profile', 'discussion', 'description']
        
        

class CommentUpdateSerializer(serializers.ModelSerializer):
    uppers = serializers.PrimaryKeyRelatedField(queryset=Profile.objects.all(), many=True)
    downers = serializers.PrimaryKeyRelatedField(queryset=Profile.objects.all(), many=True)

    class Meta:
        model = Comment
        fields = ['uppers', 'downers']


class DiscussionSerializer(serializers.ModelSerializer):
    profile = MinimalProfileSerializer()
    interested = MinimalProfileSerializer(many=True, required=False)
    comments = CommentSerializer(many=True, source='comment_set', read_only=True)

    class Meta:
        model = Discussion
        fields = '__all__'

class DiscussionCreateSerializer(serializers.ModelSerializer):
    profile = serializers.PrimaryKeyRelatedField(queryset=Profile.objects.all())

    class Meta:
        model = Discussion
        fields = '__all__'
        
class DiscussionUpdateSerializer(serializers.ModelSerializer):
    interested = serializers.PrimaryKeyRelatedField(queryset=Profile.objects.all(), many=True)

    class Meta:
        model = Discussion
        fields = ['interested', 'interested_count', 'comments_count']
        
        
class ForumReadSerializer(serializers.ModelSerializer):
    profile = MinimalProfileSerializer()
    members = MinimalProfileSerializer(many=True, required=False)
    discussions = DiscussionSerializer(many=True, required=False)
    

    class Meta:
        model = Forum
        fields = '__all__'

    def create(self, validated_data):
        print(validated_data)

        return validated_data
        
class ForumCreateSerializer(serializers.ModelSerializer):
    profile = serializers.PrimaryKeyRelatedField(queryset=Profile.objects.all())
    

    class Meta:
        model = Forum
        fields = '__all__'
        
class ForumUpdateSerializer(serializers.ModelSerializer):
    members = serializers.PrimaryKeyRelatedField(queryset=Profile.objects.all(), many=True, required=False)
    discussions = serializers.PrimaryKeyRelatedField(queryset=Discussion.objects.all(), many=True, required=False)

    class Meta:
        model = Forum
        fields = ['members', 'discussions']

    def update(self, instance, validated_data):
        
        # Update only members if provided
        if 'members' in validated_data:
            instance.members.set(validated_data['members'])

        # Update only discussions if provided
        if 'discussions' in validated_data:
            instance.discussions.set(validated_data['discussions'])

        instance.save()
        return instance

