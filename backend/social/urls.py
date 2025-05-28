from django.urls import path
from . import views

app_name = 'social'

urlpatterns = [
    path('forums/', views.Forums.as_view(), name='forums'),
    path('forums/<int:pk>/', views.ForumsPK.as_view(), name='forums'),
    path('discussions/', views.Discussions.as_view(), name='discussions'),
    path('discussions/<int:pk>/', views.DiscussionsPK.as_view(), name='discussions'),
    path('comments/', views.Comments.as_view(), name='comments'),
    path('comments/<int:pk>/', views.CommentsPK.as_view(), name='comments'),
]
