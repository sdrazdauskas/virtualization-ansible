from django.views.generic import ListView
from .models import Doctor
from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from appointments.models import Appointment
from django.db.models import Q
from .forms import PatientCardForm

class DoctorListView(ListView):
    model = Doctor
    template_name = "doctors/doctor_list.html"
    context_object_name = "doctors"

    def get_queryset(self):
        queryset = super().get_queryset()
        name = self.request.GET.get('name')
        level = self.request.GET.get('level')
        if name: 
            queryset = queryset.filter( Q(user__first_name__icontains=name) | Q(user__last_name__icontains=name) )
        if level:
            queryset = queryset.filter(specialization=level)
        return queryset

@login_required
def doctor_dashboard(request):
    user = request.user
    if not hasattr(user, 'doctor'):
        return redirect('home')  # Redirect to home if the user is not a doctor

    appointments = Appointment.objects.filter(doctor=user.doctor) 
    return render(request, 'doctors/doctor_dashboard.html', {'appointments': appointments})

@login_required
def create_patient_card(request):
    if not hasattr(request.user, 'doctor'):
        return redirect('home')  # Redirect to home if the user is not a doctor

    if request.method == 'POST':
        form = PatientCardForm(request.POST)
        if form.is_valid():
            patient_card = form.save(commit=False)
            patient_card.doctor = request.user.doctor  # Set the doctor to the logged-in user
            patient_card.save()
            return redirect('patient-card-list')  # Redirect to the patient card list after creation
    else:
        form = PatientCardForm()
    return render(request, 'doctors/create_patient_card.html', {'form': form})

