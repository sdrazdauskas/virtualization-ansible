CREATE DATABASE hospital_db;
USE hospital_db;

CREATE TABLE Patients (
patient_ssn INT PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
email VARCHAR(100),
password VARCHAR(50),
phone_number VARCHAR(15),
address VARCHAR(255),
date_of_birth DATE
);

CREATE TABLE Schedules (
schedule_id INT PRIMARY KEY,
week_day VARCHAR(255),
start_time TIME NOT NULL,
end_time TIME NOT NULL,
calendar_link VARCHAR(255)
);

CREATE TABLE Doctors (
doctor_ssn INT PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
email VARCHAR(100),
password VARCHAR(50),
specialization VARCHAR(50),
level VARCHAR(50),
phone_number VARCHAR(15),
schedule_id INT,
FOREIGN KEY (schedule_id) REFERENCES Schedules(schedule_id)
);

CREATE TABLE Appointments (
appointment_id INT PRIMARY KEY,
patient_ssn INT,
doctor_ssn INT,
appointment_date DATE NOT NULL,
status VARCHAR(50),
notes TEXT,
FOREIGN KEY (patient_ssn) REFERENCES Patients(patient_ssn),
FOREIGN KEY (doctor_ssn) REFERENCES Doctors(doctor_ssn)
);

CREATE TABLE Patient_Cards (
card_id INT PRIMARY KEY,
patient_ssn INT,
doctor_ssn INT,
visit_date DATE,
FOREIGN KEY (patient_ssn) REFERENCES Patients(patient_ssn),
FOREIGN KEY (doctor_ssn) REFERENCES Doctors(doctor_ssn)
);

insert into Patients(patient_ssn, first_name, last_name, email, password, phone_number, date_of_birth, address)
values
(5515844, 'John ', 'Smith', 'john.smith@justmail.com', 'm18uFnDc', '877371690', '1954-04-22', '56346 Gintalas Mills, Vilnius'),
(4254141, 'Emily ', 'Davis', 'emily.davis@justmail.com', '589jLVrq', '874621248', '1994-12-18', '850 Zygimantas Circle, Vilnius'),
(5813463, 'Michael ', 'Johnson', 'michael.johnson@justmail.com', 'n77eA8Vy', '876326170', '1959-12-25', '494 Rimante Parks Apt. 707, Vilnius'),
(5730559, 'David ', 'Brown', 'david.brown@justmail.com', '8tBrpX4q', '875465372', '2006-11-15', '6268 Butkus Islands, Vilnius'),
(4918766, 'Sophia ', 'Martinez', 'sophia.martinez@justmail.com', 'hN7zbTcr', '872823594', '1986-02-17', '85966 Urbonas Branch Suite 486, Vilnius'),
(4046948, 'Emma ', 'Anderson', 'emma.anderson@justmail.com', '4ViGLuAe', '876934267', '1982-07-18', '994 Rolandas Trail, Vilnius'),
(5586542, 'James ', 'Taylor', 'james.taylor@justmail.com', 'kzR3Wkqx', '878538141', '2001-12-24', '637 Poska Run, Vilnius'),
(4535389, 'Olivia ', 'Thompson', 'olivia.thompson@justmail.com', '6k8TyNje', '876548941', '1977-02-11', '322 Agne Rue, Vilnius'),
(4055836, 'Isabella ', 'White', 'isabella.white@justmail.com', '9F1sHAQn', '872671343', '1987-09-26', '719 Darija Ville Apt. 379, Vilnius'),
(4306265, 'Mia ', 'Harris', 'mia.harris@justmail.com', 'dQ4CkCEi', '875381949', '1967-04-04', '90010 Sonata Landing Apt. 097, Vilnius');

insert into Schedules(schedule_id, week_day, start_time, end_time, calendar_link)
values
(101, 'Monday-Thursday', '9:00:00', '17:00:00', NULL),
(102, 'Monday-Wednesday', '10:00:00', '19:00:00', NULL),
(103, 'Tuesday-Friday', '11:00:00', '19:00:00', NULL),
(104, 'Wednesday-Friday', '9:00:00', '17:00:00', NULL),
(105, 'Thursday-Sunday', '8:00:00', '18:00:00', NULL),
(106, 'Wednesday-Saturday', '10:00:00', '18:00:00', NULL),
(107, 'Tuesday-Wednesday', '8:00:00', '16:00:00', NULL),
(108, 'Monday-Thursday', '9:00:00', '19:00:00', NULL),
(109, 'Wednesday-Friday', '7:30:00', '15:00:00', NULL),
(110, 'Thursday-Saturday', '8:00:00', '16:30:00', NULL),
(111, 'Tuesday-Saturday', '9:00:00', '17:00:00', NULL),
(112, 'Monday-Wednesday', '11:00:00', '18:30:00', NULL);

insert into Doctors(doctor_ssn, first_name, last_name, email, password, specialization, level, phone_number, schedule_id)
values
(5123456, 'Ethan ', 'Miller', 'ethan.miller@hospital.com', 'Passw0rd1', 'Family Doctor', 'Senior Doctor', '8712345', '101'),
(5234567, 'Liam ', 'Davis', 'liam.davis@hospital.com', 'Passw0rd2', 'Cardiologist', 'Lead Specialist', '8723456', '102'),
(5345678, 'Noah ', 'Jackson', 'noah.jackson@hospital.com', 'Passw0rd3', 'Neurologist', 'Senior Doctor', '8734567', '103'),
(5456789, 'Lucas ', 'Martinez', 'lucas.martinez@hospital.com', 'Passw0rd4', 'General Practitioner', 'Consultant', '8745678', '104'),
(5567890, 'Alexander ', 'Garcia', 'alexander.garcia@hospital.com', 'Passw0rd5', 'Surgeon', 'Lead Specialist', '8756789', '105'),
(4123456, 'Charlotte ', 'Martinez', 'charlotte.martinez@hospital.com', 'Passw0rd6', 'Family Doctor', 'Senior Doctor', '8712345', '106'),
(4234567, 'Amelia ', 'Lopez', 'amelia.lopez@hospital.com', 'Passw0rd7', 'Pediatrician', 'Lead Specialist', '8723456', '107'),
(4345678, 'Isabella ', 'Gonzalez', 'isabella.gonzalez@hospital.com', 'Passw0rd8', 'Gynecologist', 'Consultant', '8734567', '108'),
(4456789, 'Mia ', 'Perez', 'mia.perez@hospital.com', 'Passw0rd9', 'Dermatologist', 'Senior Doctor', '8745678', '109'),
(4567890, 'Harper ', 'Lee', 'harper.lee@hospital.com', 'Passw0rd10', 'Ophthalmologist', 'Lead Specialist', '8756789', '110'),
(4678901, 'Evelyn ', 'Turner', 'evelyn.turner@hospital.com', 'Passw0rd11', 'Neurologist', 'Consultant', '8767890', '111'),
(4789012, 'Aria ', 'Walker', 'aria.walker@hospital.com', 'Passw0rd12', 'Surgeon', 'Senior Doctor', '8778901', '112');

insert into Appointments(appointment_id, patient_ssn, doctor_ssn, appointment_date, status, notes)
values
(1, 4918766, 4234567, '2024-04-21', 'Completed', 'Child wellness visit'),
(2, 5515844, 4345678, '2024-08-05', 'Completed', 'Consultation for reproductive health'),
(3, 4535389, 5567890, '2024-09-15', 'Completed', 'Post-surgery follow-up.'),
(4, 5730559, 5234567, '2024-10-20', 'Completed', 'Annual cardiology check-up.'),
(5, 4055836, 4456789, '2024-11-20', 'Scheduled', 'Skin check-up and consultation'),
(6, 5586542, 5456789, '2024-11-25', 'Scheduled', 'Routine physical examination'),
(7, 4535389, 5345678, '2024-12-01', 'Scheduled', 'Consultation for headache and dizziness'),
(8, 5586542, 4123456, '2024-12-10', 'Scheduled', 'General health check for new patient'),
(9, 4306265, 5123456, '2024-12-15', 'Scheduled', 'Follow-up visit for general health check');

insert into Patient_Cards(card_id, patient_ssn, doctor_ssn, visit_date)
values
(1, 5515844, 4123456, '2024-08-05'),
(2, 4254141, 5123456, NULL),
(3, 5813463, 5123456, NULL),
(4, 5730559, 4123456, '2024-10-20'),
(5, 4918766, 4123456, '2024-04-21'),
(6, 4046948, 4123456, NULL),
(7, 5586542, 5123456, NULL),
(8, 4535389, 4123456, '2024-09-15'),
(9, 4055836, 5123456, NULL),
(10, 4306265, 4123456, NULL);