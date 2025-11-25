/*Hospital Patient Record System – 
 Project Overview
A hospital needs a structured way to store and access patient history, visits, diagnosis, and prescriptions. 
This project builds a complete patient record management system using SQL.*/
--------------------------------------------------------------------------------------------------------------------------------------------------

/*  Hospital Patient Record System
      Business Problem: Doctors need fast access to patient history.
      Solution: Designed patients, visits, prescription tables + views for summaries.*/
      
      CREATE DATABASE HospitalDB;
      USE HospitalDB;

CREATE TABLE Patients (
    PatientID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(100),
    Gender VARCHAR(10),
    Age INT,
    Contact VARCHAR(20)
);

CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY AUTO_INCREMENT,
    DoctorName VARCHAR(100),
    Specialization VARCHAR(50)
);

CREATE TABLE Visits (
    VisitID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    DoctorID INT,
    VisitDate DATE,
    Diagnosis VARCHAR(255),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

CREATE TABLE Medicines (
    MedicineID INT PRIMARY KEY AUTO_INCREMENT,
    MedicineName VARCHAR(100),
    Type VARCHAR(50)
);

CREATE TABLE Prescriptions (
    PrescriptionID INT PRIMARY KEY AUTO_INCREMENT,
    VisitID INT,
    MedicineID INT,
    Dosage VARCHAR(50),
    Duration VARCHAR(50),
    FOREIGN KEY (VisitID) REFERENCES Visits(VisitID),
    FOREIGN KEY (MedicineID) REFERENCES Medicines(MedicineID)
);

INSERT INTO Patients (FullName, Gender, Age, Contact) VALUES
('Rohit Kumar', 'Male', 32, '9876543210'),
('Sneha Patil', 'Female', 28, '9988776655'),
('John Carter', 'Male', 45, '8877665544');

INSERT INTO Doctors (DoctorName, Specialization) VALUES
('Dr. Anjali Singh', 'Cardiology'),
('Dr. Ravi Deshmukh', 'Orthopedic'),
('Dr. Maria Johnson', 'Dermatology');

INSERT INTO Visits (PatientID, DoctorID, VisitDate, Diagnosis) VALUES
(1, 1, '2024-01-10', 'High Blood Pressure'),
(2, 3, '2024-01-12', 'Skin Allergy'),
(1, 1, '2024-02-05', 'Chest Pain');

INSERT INTO Medicines (MedicineName, Type) VALUES
('Paracetamol', 'Tablet'),
('Atorvastatin', 'Tablet'),
('Antihistamine', 'Syrup');

INSERT INTO Prescriptions (VisitID, MedicineID, Dosage, Duration) VALUES
(1, 2, '10mg', '30 days'),
(2, 3, '2 tsp', '7 days'),
(3, 1, '500mg', '5 days');

-- 1. LIST ALL PATIENTS
SELECT * FROM Patients;

-- 2.PATIENT VISIT HISTORY
SELECT 
    P.FullName,
    V.VisitDate,
    V.Diagnosis,
    D.DoctorName
FROM Patients P
JOIN Visits V ON P.PatientID = V.PatientID
JOIN Doctors D ON V.DoctorID = D.DoctorID
WHERE P.PatientID = 1;

-- 3.TOP DOCTORS BY NO OF PATIENTS
SELECT 
    D.DoctorName,
    COUNT(V.VisitID) AS TotalVisits
FROM Doctors D
JOIN Visits V ON D.DoctorID = V.DoctorID
GROUP BY D.DoctorName
ORDER BY TotalVisits DESC;

-- 4.MEDICINE PRESCRIBED COUNT
SELECT 
    M.MedicineName,
    COUNT(PrescriptionID) AS PrescribedCount
FROM Medicines M
JOIN Prescriptions P ON M.MedicineID = P.MedicineID
GROUP BY M.MedicineName;

-- 5.MOST COMMON DIAGNOSES
SELECT Diagnosis, COUNT(*) AS TotalCases
FROM Visits
GROUP BY Diagnosis
ORDER BY TotalCases DESC;