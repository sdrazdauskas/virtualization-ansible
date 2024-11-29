from django import forms
from django.contrib.auth.forms import AuthenticationForm
from patients.models import PatientCard

class DoctorLoginForm(AuthenticationForm):
    username = forms.CharField(widget=forms.TextInput(attrs={'class': 'form-control'}))
    password = forms.CharField(widget=forms.PasswordInput(attrs={'class': 'form-control'}))

class PatientCardForm(forms.ModelForm):
    class Meta:
        model = PatientCard
        fields = ['patient', 'medical_history']