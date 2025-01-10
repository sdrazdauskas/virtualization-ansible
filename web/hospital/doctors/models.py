from django.db import models
from django.contrib.auth.models import User

class Doctor(models.Model):
    LEVEL_CHOICES = [
        ('GP', 'General Practitioner'),
        ('CARD', 'Cardiologist'),
        ('NEURO', 'Neurologist'),
    ]

    user = models.OneToOneField(User, on_delete=models.CASCADE)
    specialization = models.CharField(max_length=50, choices=LEVEL_CHOICES)
    phone = models.CharField(max_length=15)
    work_schedule = models.TextField()

    def __str__(self):
        return f"Dr. {self.user.last_name}"

class Schedule(models.Model):
    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE, related_name="schedules")
    date = models.DateField()
    time_start = models.TimeField()
    time_end = models.TimeField()

    def __str__(self):
        return f"{self.doctor} - {self.date}"
