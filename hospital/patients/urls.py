from django.urls import path
from .views import register_patient
from .views import registration_success, patient_card_list

urlpatterns = [
    path('register-patient/', register_patient, name='register-patient'),
    path('registration-success/', registration_success, name='registration-success'),
    path('cards/', patient_card_list, name='patient-card-list'),
]