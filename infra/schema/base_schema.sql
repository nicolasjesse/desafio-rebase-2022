CREATE TABLE IF NOT EXISTS examination (
  id SERIAL PRIMARY KEY,
  token VARCHAR(6),
  doctor_code VARCHAR(10),
  doctor_name VARCHAR(200) NOT NULL,
  doctor_email VARCHAR(50) NOT NULL,
  doctor_state_code VARCHAR(2) NOT NULL,
  patient_code VARCHAR(14),
  patient_name VARCHAR(200) NOT NULL,
  patient_email VARCHAR(50) NOT NULL,
  patient_birth_date DATE NOT NULL,
  patient_street VARCHAR(100) NOT NULL,
  patient_city VARCHAR(100) NOT NULL,
  patient_state VARCHAR(100) NOT NULL,
  date DATE NOT NULL,
  type VARCHAR NOT NULL,
  type_limit VARCHAR NOT NULL,
  result VARCHAR NOT NULL
);