from django.urls import path
from .views import DoctorListView, doctor_dashboard, create_patient_card

urlpatterns = [
    path('list/', DoctorListView.as_view(), name='doctor-list'),
    path('dashboard/', doctor_dashboard, name='doctor-dashboard'),
    path('create-patient-card', create_patient_card, name='create-patient-card'),
]