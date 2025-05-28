from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from .serializer import *
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response

# Create your views here.
class Forums(APIView):
    def get(self, request):
        forums = Forum.objects.all()
        forums_serializer = ForumReadSerializer(forums, many=True)
        return Response({'forums': forums_serializer.data}, status=status.HTTP_200_OK)
    
    def post(self, request):
        user = request.data.get('profile')
        actual_profile = Profile.objects.filter(user=user).first().id
        data = request.data.copy()
        data['profile'] = f'{actual_profile}'
        serializer = ForumCreateSerializer(data=data)
        if serializer.is_valid():
            forum = serializer.save()
            forum_serializer = ForumReadSerializer(forum)
            return Response({'new forum':forum_serializer.data}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
class ForumsPK(APIView):
    
    def get(self, request, pk):
        forums = Forum.objects.filter(pk=pk).first()
        forums_serializer = ForumReadSerializer(forums)
        return Response({'forums': forums_serializer.data}, status=status.HTTP_200_OK)
    
    def put(self, request, pk):
        try:
            forum = Forum.objects.get(pk=pk)
        except Forum.DoesNotExist:
            return Response({"detail": "Forum not found."}, status=status.HTTP_404_NOT_FOUND)

        serializer = ForumUpdateSerializer(forum, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk):
        forum = Forum.objects.filter(pk=pk).first()
        if not forum:
            return Response({"detail": "Forum not found."}, status=status.HTTP_404_NOT_FOUND)

        forum.delete()
        return Response({"detail": "Forum deleted."}, status=status.HTTP_204_NO_CONTENT)
    
    
    
    
    
class Discussions(APIView):
    def get(self, request):
        discussions = Discussion.objects.all()
        serializer = DiscussionSerializer(discussions, many=True)
        return Response({'discussions': serializer.data}, status=status.HTTP_200_OK)

    def post(self, request):
        user = request.data.get('profile')
        actual_profile = Profile.objects.filter(user=user).first().id
        data = request.data.copy()
        data['profile'] = f'{actual_profile}'
        serializer = DiscussionCreateSerializer(data=data)
        if serializer.is_valid():
            discussion = serializer.save()
            profile = serializer.validated_data.get('profile')
            profile.discussions_count += 1
            profile.save()
            return Response({'new discussion': DiscussionSerializer(discussion).data}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class DiscussionsPK(APIView):
    def get(self, request, pk):
        discussion = Discussion.objects.filter(pk=pk).first()
        if not discussion:
            return Response({"detail": "Discussion not found."}, status=status.HTTP_404_NOT_FOUND)

        serializer = DiscussionSerializer(discussion)
        return Response({'discussion': serializer.data, 'comments': CommentSerializer(Comment.objects.filter(discussion=discussion))}, status=status.HTTP_200_OK)
    
    def put(self, request, pk):
        discussion = Discussion.objects.filter(pk=pk).first()
        if not discussion:
            return Response({"detail": "Discussion not found."}, status=status.HTTP_404_NOT_FOUND)

        serializer = DiscussionUpdateSerializer(discussion, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            discussion.save()
            return Response(serializer.data, status=status.HTTP_200_OK)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, pk):
        discussion = Discussion.objects.filter(pk=pk).first()
        if not discussion:
            return Response({"detail": "Discussion not found."}, status=status.HTTP_404_NOT_FOUND)

        discussion.delete()
        return Response({"detail": "Discussion deleted."}, status=status.HTTP_204_NO_CONTENT)
    
    
    
    
class Comments(APIView):
    def get(self, request):
        comments = Comment.objects.all()
        serializer = CommentSerializer(comments, many=True)
        return Response({'comments': serializer.data}, status=status.HTTP_200_OK)

    def post(self, request):
        serializer = CommentCreateSerializer(data=request.data)
        if serializer.is_valid():
            comment = serializer.save()
            return Response({'new comment': CommentSerializer(comment).data}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class CommentsPK(APIView):
    def get(self, request, pk):
        comment = Comment.objects.filter(pk=pk).first()
        if not comment:
            return Response({"detail": "Comment not found."}, status=status.HTTP_404_NOT_FOUND)

        serializer = CommentSerializer(comment)
        return Response({'comment': serializer.data}, status=status.HTTP_200_OK)

    def put(self, request, pk):
        comment = Comment.objects.filter(pk=pk).first()
        if not comment:
            return Response({"detail": "Comment not found."}, status=status.HTTP_404_NOT_FOUND)

        serializer = CommentUpdateSerializer(comment, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            comment.save()
            return Response(CommentSerializer(comment).data, status=status.HTTP_200_OK)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        comment = Comment.objects.filter(pk=pk).first()
        if not comment:
            return Response({"detail": "Comment not found."}, status=status.HTTP_404_NOT_FOUND)

        comment.delete()
        return Response({"detail": "Comment deleted."}, status=status.HTTP_204_NO_CONTENT)
