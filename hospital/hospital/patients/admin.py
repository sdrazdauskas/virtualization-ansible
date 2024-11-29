from django.contrib import admin
from .models import PatientCard

@admin.register(PatientCard)
class PatientCardAdmin(admin.ModelAdmin):
    list_display = ('patient', 'doctor', 'created_at')
    search_fields = ('patient__user__first_name', 'patient__user__last_name', 'doctor__user__first_name', 'doctor__user__last_name')
    list_filter = ('created_at',)
