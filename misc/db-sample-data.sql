USE hospital_db;

-- Create Users
INSERT INTO auth_user (username, password, first_name, last_name, email, is_staff, is_active, is_superuser, date_joined)
VALUES ('doctor1', 'pbkdf2_sha256$260000$...$...', 'John', 'Doe', 'doctor1@example.com', 1, 1, 0, NOW());

INSERT INTO auth_user (username, password, first_name, last_name, email, is_staff, is_active, is_superuser, date_joined)
VALUES ('patient1', 'pbkdf2_sha256$260000$...$...', 'Jane', 'Smith', 'patient1@example.com', 0, 1, 0, NOW());

-- Create Doctor
INSERT INTO doctors_doctor (user_id, specialization, phone, work_schedule)
VALUES ((SELECT id FROM auth_user WHERE username='doctor1'), 'GP', '1234567890', 'Mon-Fri 9am-5pm');

-- Create Schedule
INSERT INTO doctors_schedule (doctor_id, date, time_start, time_end)
VALUES ((SELECT id FROM doctors_doctor WHERE user_id=(SELECT id FROM auth_user WHERE username='doctor1')), '2024-12-01', '09:00:00', '17:00:00');

-- Create Patient
INSERT INTO patients_patient (user_id, phone, address)
VALUES ((SELECT id FROM auth_user WHERE username='patient1'), '0987654321', '123 Main St');

-- Create PatientCard
INSERT INTO patients_patientcard (patient_id, doctor_id, medical_history, created_at)
VALUES ((SELECT id FROM patients_patient WHERE user_id=(SELECT id FROM auth_user WHERE username='patient1')), (SELECT id FROM doctors_doctor WHERE user_id=(SELECT id FROM auth_user WHERE username='doctor1')), 'No known allergies', NOW());

-- Create Appointment
INSERT INTO appointments_appointment (patient_id, doctor_id, date, time)
VALUES ((SELECT id FROM patients_patient WHERE user_id=(SELECT id FROM auth_user WHERE username='patient1')), (SELECT id FROM doctors_doctor WHERE user_id=(SELECT id FROM auth_user WHERE username='doctor1')), '2024-12-02', '10:00:00');
