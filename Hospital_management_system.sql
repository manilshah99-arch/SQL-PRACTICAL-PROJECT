CREATE DATABASE Hospital_management;
USE Hospital_management;

CREATE TABLE Patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    dob DATE,
    gender VARCHAR(10),
    phone_number VARCHAR(15),
    email VARCHAR(100),
    address TEXT,
    registration_date DATE
);

CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    specialization VARCHAR(100),
    phone_number VARCHAR(15),
    email VARCHAR(100),
    available_days VARCHAR(100),
    consultation_fee DECIMAL(10,2),
    experience_years INT
);

CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    status ENUM('Scheduled','Completed','Cancelled'),

    FOREIGN KEY (patient_id)
    REFERENCES Patients(patient_id)
    ON DELETE CASCADE,

    FOREIGN KEY (doctor_id)
    REFERENCES Doctors(doctor_id)
    ON DELETE CASCADE
);

CREATE TABLE MedicalRecords (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    doctor_id INT,
    diagnosis TEXT,
    prescription TEXT,
    treatment_date DATE,

    FOREIGN KEY (patient_id)
    REFERENCES Patients(patient_id)
    ON DELETE CASCADE,

    FOREIGN KEY (doctor_id)
    REFERENCES Doctors(doctor_id)
    ON DELETE CASCADE
);

CREATE TABLE Billing (
    invoice_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    appointment_id INT,
    amount DECIMAL(10,2),
    payment_status ENUM('Paid','Pending','Cancelled'),
    payment_date DATE,

    FOREIGN KEY (patient_id)
    REFERENCES Patients(patient_id)
    ON DELETE CASCADE,

    FOREIGN KEY (appointment_id)
    REFERENCES Appointments(appointment_id)
    ON DELETE CASCADE
);

CREATE TABLE Departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100)
);

CREATE TABLE Doctor_Department (
    doctor_id INT,
    department_id INT,

    PRIMARY KEY (doctor_id, department_id),

    FOREIGN KEY (doctor_id)
    REFERENCES Doctors(doctor_id)
    ON DELETE CASCADE,

    FOREIGN KEY (department_id)
    REFERENCES Departments(department_id)
    ON DELETE CASCADE
);

INSERT INTO Patients
(name, dob, gender, phone_number, email, address, registration_date)
VALUES
('Rahul Sharma', '1999-05-10', 'Male', '9876543210',
'rahul@gmail.com', 'Delhi', '2025-01-01'),

('Priya Verma', '2000-07-15', 'Female', '9876543211',
'priya@gmail.com', 'Mumbai', '2025-02-01'),

('Amit Singh', '1998-11-20', 'Male', '9876543212',
'amit@gmail.com', 'Pune', '2025-03-01');

INSERT INTO Doctors
(name, specialization, phone_number, email,
available_days, consultation_fee, experience_years)
VALUES
('Dr. Mehta', 'Cardiology', '9991111111',
'mehta@gmail.com', 'Mon,Wed,Fri', 1500, 16),

('Dr. Roy', 'Neurology', '9992222222',
'roy@gmail.com', 'Tue,Thu', 1200, 8),

('Dr. Khan', 'Dermatology', '9993333333',
'khan@gmail.com', 'Mon-Sat', 900, 3);

INSERT INTO Appointments
(patient_id, doctor_id, appointment_date, status)
VALUES
(1,1,'2025-05-01','Completed'),
(2,2,'2025-05-03','Scheduled'),
(3,3,'2025-05-05','Cancelled'),
(1,2,'2025-05-06','Completed');

INSERT INTO MedicalRecords
(patient_id, doctor_id, diagnosis, prescription, treatment_date)
VALUES
(1,1,'Heart Problem','Medicine A','2025-05-01'),
(2,2,'Migraine','Medicine B','2025-05-03'),
(1,2,'Stress','Medicine C','2025-05-06');

INSERT INTO Billing
(patient_id, appointment_id, amount,
payment_status, payment_date)
VALUES
(1,1,1500,'Paid','2025-05-01'),
(2,2,1200,'Pending','2025-05-03'),
(3,3,900,'Cancelled','2025-05-05');

INSERT INTO Departments (department_name)
VALUES
('Cardiology'),
('Neurology'),
('Dermatology');

INSERT INTO Doctor_Department
(doctor_id, department_id)
VALUES
(1,1),
(2,2),
(3,3);

INSERT INTO Patients
(name, dob, gender, phone_number, email, address, registration_date)
VALUES
('Neha', '2001-04-10', 'Female',
'9998887777', 'neha@gmail.com',
'Bangalore', CURDATE());

UPDATE Patients
SET address = 'Chennai'
WHERE patient_id = 1;

DELETE FROM Appointments
WHERE status = 'Cancelled';

SELECT *
FROM Patients
WHERE registration_date >= '2025-01-01';

SELECT *
FROM Doctors
WHERE consultation_fee > 1000;

SELECT doctor_id, COUNT(*) AS total
FROM Appointments
GROUP BY doctor_id
HAVING total > 1;

SELECT *
FROM Patients
LIMIT 5;

SELECT *
FROM Appointments
WHERE status = 'Scheduled'
AND doctor_id = 2;

SELECT *
FROM Doctors
WHERE specialization IN ('Cardiology', 'Neurology');

SELECT *
FROM Doctors
WHERE specialization = 'Dermatology';

SELECT *
FROM Patients
WHERE patient_id NOT IN (
    SELECT patient_id
    FROM Appointments
);

SELECT specialization, COUNT(*) AS total_doctors
FROM Doctors
GROUP BY specialization
ORDER BY total_doctors DESC;

SELECT SUM(amount) AS total_revenue
FROM Billing;

SELECT AVG(consultation_fee) AS avg_fee
FROM Doctors;

SELECT MAX(consultation_fee) AS highest_fee
FROM Doctors;

SELECT MIN(consultation_fee) AS lowest_fee
FROM Doctors;

SELECT doctor_id, COUNT(*) AS total_visits
FROM Appointments
GROUP BY doctor_id
ORDER BY total_visits DESC
LIMIT 1;

SELECT d.name, dep.department_name
FROM Doctors d
INNER JOIN Doctor_Department dd
ON d.doctor_id = dd.doctor_id
INNER JOIN Departments dep
ON dd.department_id = dep.department_id;

SELECT p.name, a.status
FROM Patients p
LEFT JOIN Appointments a
ON p.patient_id = a.patient_id;

SELECT b.invoice_id, a.appointment_id
FROM Billing b
RIGHT JOIN Appointments a
ON b.appointment_id = a.appointment_id;

SELECT p.patient_id, a.appointment_id
FROM Patients p
LEFT JOIN Appointments a
ON p.patient_id = a.patient_id

UNION

SELECT p.patient_id, a.appointment_id
FROM Patients p
RIGHT JOIN Appointments a
ON p.patient_id = a.patient_id;

SELECT a.appointment_id
FROM Appointments a
LEFT JOIN Billing b
ON a.appointment_id = b.appointment_id
WHERE b.invoice_id IS NULL;

SELECT doctor_id
FROM Appointments
GROUP BY doctor_id
HAVING COUNT(DISTINCT patient_id) > 1;

SELECT patient_id, SUM(amount) AS total
FROM Billing
GROUP BY patient_id
ORDER BY total DESC
LIMIT 1;

SELECT MONTH(appointment_date) AS month,
COUNT(*) AS total
FROM Appointments
GROUP BY MONTH(appointment_date);

SELECT DATEDIFF('2025-05-10', '2025-05-01')
AS total_days;

SELECT DATE_FORMAT(treatment_date, '%d-%m-%Y')
FROM MedicalRecords;

SELECT UPPER(name)
FROM Patients;

SELECT LENGTH(name)
FROM Patients;

SELECT REPLACE(phone_number, '987', '999')
FROM Patients;

SELECT TRIM(name)
FROM Patients;

SELECT name,
consultation_fee,
RANK() OVER (ORDER BY consultation_fee DESC) AS ranking
FROM Doctors;

SELECT appointment_id,
COUNT(*) OVER (
ORDER BY appointment_date
) AS running_total
FROM Appointments;

SELECT patient_id,
CASE
    WHEN COUNT(record_id) > 5 THEN 'High'
    WHEN COUNT(record_id) BETWEEN 3 AND 5 THEN 'Medium'
    ELSE 'Low'
END AS risk_level
FROM MedicalRecords
GROUP BY patient_id;

SELECT name,
CASE
    WHEN experience_years > 15 THEN 'Senior'
    WHEN experience_years BETWEEN 5 AND 15 THEN 'Mid-Level'
    ELSE 'Junior'
END AS category
FROM Doctors;