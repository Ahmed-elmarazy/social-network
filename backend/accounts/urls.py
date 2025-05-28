from django.urls import path, reverse_lazy
from . import views
# email verify imports
from django.contrib.auth import views as auth_views

app_name='accounts'

urlpatterns = [
    #Api urls
    path('signup/',views.Signup.as_view(),name='signup'),
    path('login/',views.Login.as_view(),name='login'),
    # path('logout/',views.Logout.as_view(),name='logout'),
    # #Api profile urls
    path('profile/<int:user_pk>/<int:viewer_pk>/',views.UserProfile.as_view(),name='user_profile'),
    # #Api reset password urls
    # path('reset-email/<str:profile_slug>/',views.RequestPasswordResetEmail.as_view(),name='reset_email'),
    # path('request-password/<str:profile_slug>/<str:uidb64>/<str:token>/',views.ResetPassword.as_view(),name='request_password'),
]
