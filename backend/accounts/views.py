from rest_framework import serializers
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from .serializer import *
from django.contrib.auth.models import User
from django.contrib.auth import authenticate,login
# user activation 
from django.contrib.sites.shortcuts import get_current_site
from django.utils.http import urlsafe_base64_decode,urlsafe_base64_encode
from django.utils.encoding import force_bytes
from django.conf import settings
from django.core.mail import send_mail
from django.contrib.auth.tokens import default_token_generator,PasswordResetTokenGenerator 
from django.core.mail import EmailMultiAlternatives
# rest framework imports
from rest_framework.authtoken.models import Token
from rest_framework import generics,status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated,AllowAny
from rest_framework.authtoken.models import Token
from rest_framework.authentication import TokenAuthentication
from social.models import Discussion, Forum
from social.serializer import DiscussionSerializer, ForumReadSerializer

# serializer imports
from .serializer import *

class Login(APIView):
    def post(self, request):
        serializer = LoginSerializer(data=request.data)
        if serializer.is_valid():
            email = serializer.validated_data['email']
            password = serializer.validated_data['password']
            try:
                user_email = User.objects.get(email=email)  # to get username
                user = authenticate(request, username=user_email.username, password=password)
                if user is None:
                    return Response({'message': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)
                
                token, created = Token.objects.get_or_create(user=user)
                json = {
                    'message': 'login success',
                    'user': user.id,
                    'token': token.key   
                }
                return Response(json, status=status.HTTP_200_OK)
            except User.DoesNotExist:
                return Response({'message': 'user does not exist'}, status=status.HTTP_404_NOT_FOUND)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class Signup(APIView):
    def post(self, request):
        try:
            email = request.data.get('email')
            if User.objects.filter(email=email).exists():
                user = User.objects.get(email=email)
                return Response({
                    'message': 'User already exists',
                    'user_id': user.id
                }, status=status.HTTP_226_IM_USED)

            first_name = request.data.get('first_name')
            last_name = request.data.get('last_name')
            password = request.data.get('password')

            if not all([email, first_name, last_name, password]):
                return Response({'message': 'Missing required fields'}, status=status.HTTP_400_BAD_REQUEST)

            username = email.split('@')[0]

            user = User.objects.create_user(
                username=username,
                email=email,
                password=password,
                first_name=first_name,
                last_name=last_name
            )
            user.is_active = True
            user.save()

            Profile.objects.create(user=user)

            return Response({
                'message': "You're all set!",
                'user_id': user.id
            }, status=status.HTTP_201_CREATED)

        except Exception as e:
            print("Signup error:", e)
            return Response({'message': 'Registration failed', 'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    
    
from rest_framework.parsers import MultiPartParser, FormParser

class UserProfile(APIView):
    parser_classes = [MultiPartParser, FormParser]  # to support image upload

    def get(self, request, user_pk, viewer_pk):
        print(user_pk , viewer_pk)
        user = User.objects.filter(pk=user_pk).first()
        # the user to fetch
        viewer =  User.objects.filter(pk=viewer_pk).first()
        try:
            profile = Profile.objects.get(user=user)
            if user == viewer:
                profile.views += 1
                profile.save()
            profile_serializer = ProfileSerializer(profile)

            return Response({
                'user_data': {
                    'first_name': user.first_name,
                    'last_name': user.last_name,
                    'email': user.email
                },
                'profile_data': profile_serializer.data,
                'discussions': DiscussionSerializer(Discussion.objects.filter(profile=profile), many=True).data,
                'forum': ForumReadSerializer(Forum.objects.filter(profile=profile), many=True).data,
            }, status=status.HTTP_200_OK)

        except Profile.DoesNotExist:
            return Response({'message': 'User profile does not exist'}, status=status.HTTP_404_NOT_FOUND)

    def put(self, request, user_pk, viewer_pk):
        user = User.objects.filter(pk=user_pk).first()
        if not user:
            return Response({'message': 'User not found'}, status=status.HTTP_404_NOT_FOUND)

        try:
            profile = Profile.objects.get(user=user)
        except Profile.DoesNotExist:
            return Response({'message': 'User profile does not exist'}, status=status.HTTP_404_NOT_FOUND)

        serializer = ProfileSerializer(profile, data=request.data, partial=True, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response({'message': 'Profile updated successfully', 'profile_data': serializer.data}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
