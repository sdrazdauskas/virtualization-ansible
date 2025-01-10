# appointments/urls.py
from django.urls import path
from .views import create_appointment, appointment_list

urlpatterns = [
    path('', appointment_list, name='appointment_list'),
    path('create/', create_appointment, name='create-appointment'),
]