from django import forms
from .models import Appointment

class AppointmentForm(forms.ModelForm):
    date = forms.DateField(widget=forms.DateInput(attrs={'type': 'date'}))

    class Meta:
        model = Appointment
        fields = ['doctor', 'date', 'time']
