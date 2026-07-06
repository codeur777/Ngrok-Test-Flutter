from django.urls import path
from . import views

urlpatterns = [
    path('bonjour/', views.bonjour, name='bonjour'),
]
