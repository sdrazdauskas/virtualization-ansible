from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from .forms import UserRegistrationForm, PatientRegistrationForm
from .models import PatientCard

def registration_success(request): 
    return render(request, 'patients/registration_success.html')

def register_patient(request):
    if request.method == 'POST':
        user_form = UserRegistrationForm(request.POST)
        patient_form = PatientRegistrationForm(request.POST)
        if user_form.is_valid() and patient_form.is_valid():
            user = user_form.save(commit=False)
            user.set_password(user_form.cleaned_data['password'])
            user.save()
            patient = patient_form.save(commit=False)
            patient.user = user
            patient.save()
            
            # Authenticate and log in the user
            user = authenticate(username=user_form.cleaned_data['username'], password=user_form.cleaned_data['password'])
            if user is not None:
                login(request, user)
                return redirect('registration-success')
    else:
        user_form = UserRegistrationForm()
        patient_form = PatientRegistrationForm()
    return render(request, 'patients/register_patient.html', {'user_form': user_form, 'patient_form': patient_form})

@login_required
def patient_card_list(request):
    user = request.user
    if not hasattr(user, 'patient'):
        return redirect('home')  # Redirect to home if the user is not a patient

    patient_cards = PatientCard.objects.filter(patient=user.patient)
    return render(request, 'patients/patient_card_list.html', {'patient_cards': patient_cards})
