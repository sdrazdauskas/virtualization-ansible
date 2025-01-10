from django import forms
from django.contrib.auth.models import User
from .models import Patient

class UserRegistrationForm(forms.ModelForm):
    password = forms.CharField(widget=forms.PasswordInput)
    class Meta:
        model = User
        fields = ['username', 'password', 'first_name', 'last_name', 'email']

class PatientRegistrationForm(forms.ModelForm):
    class Meta:
        model = Patient
        fields = ['phone', 'address']