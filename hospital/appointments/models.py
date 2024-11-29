from django.db import models
from doctors.models import Doctor  # Import the Doctor model
from patients.models import Patient  # Import the Patient model

class Appointment(models.Model):
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE, related_name="appointments")
    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE, related_name="appointments")
    date = models.DateField()
    time = models.TimeField()

    def __str__(self):
        return f"Appointment: {self.patient} with {self.doctor} on {self.date} at {self.time}"
