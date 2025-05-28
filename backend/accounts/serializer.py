from rest_framework import serializers   
from .models import Profile, Interest, User

class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model=Profile
        fields='__all__'

class InterestSerializer(serializers.ModelSerializer):
    class Meta:
        model=Interest
        fields='__all__'
        

class UserSerializer(serializers.ModelSerializer):
    password2=serializers.CharField(style={'input_type':'password'}, write_only=True)
    class Meta:
        model = User
        fields = ['first_name','last_name','email','password','password2']
        extra_kwargs = {'password': {'write_only': True}}
        
    def save(self):
        password1=self.validated_data['password']
        password2=self.validated_data['password2']
        if password1 !=password2:
            raise serializers.ValidationError({'error':'passwords do not match'})
        
    


class LoginSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['email','password']
        extra_kwargs = {'email':{'required':True},'password': {'write_only': True}}


class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = '__all__'

    def get_non_editable_fields(self):
        # Fields that should NOT be editable
        return ['views', 'discussions_count', 'discussions_interacted_with', 'user']

    def validate(self, data):
        request = self.context.get('request')
        if request and request.method in ['PUT', 'PATCH']:
            non_editable_fields = self.get_non_editable_fields()
            for field in list(data.keys()):
                if field in non_editable_fields:
                    data.pop(field)
        return data


class ChangePasswordSerializer(serializers.ModelSerializer):
    
    old_password=serializers.CharField(style={'input_type':'password'}, write_only=True)
    new_password=serializers.CharField(style={'input_type':'password'}, write_only=True)
    confirm_password=serializers.CharField(style={'input_type':'password'}, write_only=True)
    class Meta:
        model=User
        fields=['old_password','new_password','confirm_password']
        extra_kwargs = {
                        'old_password': {'write_only': True},
                        'new_password': {'write_only': True},
                        'confirm_password': {'write_only': True}
                        }


class RequestPasswordResetEmailSerializer(serializers.ModelSerializer):
    class Meta:
        model=User
        fields=['email']
        extra_kwargs = {'email':{'required':True}}
