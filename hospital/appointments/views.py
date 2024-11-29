from django.shortcuts import redirect, render
from django.contrib.auth.decorators import login_required
from .models import Appointment
from .forms import AppointmentForm

def appointment_list(request):
    user = request.user
    if user.is_authenticated:
        appointments = Appointment.objects.filter(patient__user=user)  # Filter appointments for the logged-in user
    else:
        appointments = Appointment.objects.none()  # Return an empty queryset if the user is not authenticated
    return render(request, 'appointments/appointment_list.html', {'appointments': appointments})

@login_required
def create_appointment(request):
    user = request.user
    if not hasattr(user, 'patient'):
        return redirect('register-patient')  # Redirect to a page where the user can create a Patient object
    
    if request.method == 'POST':
        form = AppointmentForm(request.POST)
        if form.is_valid():
            appointment = form.save(commit=False)
            appointment.patient = user.patient  # Associate the appointment with the logged-in patient
            appointment.save()
            return redirect('appointment_list')  # Redirect to the appointment list or another success page
    else:
        form = AppointmentForm()
    return render(request, 'appointments/create_appointment.html', {'form': form})
