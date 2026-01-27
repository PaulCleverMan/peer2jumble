from django.urls import path
from .views import stub_view

urlpatterns = [
    path('', stub_view, name='accounts'),
    path('login/', stub_view, name='login'),
    path('register/', stub_view, name='register'),
]