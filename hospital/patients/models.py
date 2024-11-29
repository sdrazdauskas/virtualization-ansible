from django.db import models
from django.contrib.auth.models import User
from patients.models import Patient
from doctors.models import Doctor

class Patient(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    phone = models.CharField(max_length=15)
    address = models.TextField()

    def __str__(self):
        return f"{self.user.first_name} {self.user.last_name}"

class PatientCard(models.Model):
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE, related_name="cards")
    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE, related_name="filled_cards", null=True, blank=True)
    medical_history = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    def __str__(self):
        return f"Card for {self.patient} by Dr. {self.doctor.user.last_name}"