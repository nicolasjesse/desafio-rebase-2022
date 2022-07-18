CREATE TABLE patient (
  code VARCHAR(14) PRIMARY KEY,
  name_of VARCHAR(200) NOT NULL,
  email VARCHAR(50) UNIQUE NOT NULL,
  birth_date DATE NOT NULL,
  street VARCHAR(100) NOT NULL,
  city VARCHAR(100) NOT NULL,
  state_of VARCHAR(100) NOT NULL
);

CREATE TABLE doctor (
  code VARCHAR(10) PRIMARY KEY,
  name_of VARCHAR(200) NOT NULL,
  email VARCHAR(50) UNIQUE NOT NULL,
  state_code VARCHAR(2) NOT NULL
);

CREATE TABLE exam_type (
  id SERIAL PRIMARY KEY,
  description_of VARCHAR NOT NULL,
  limit_of VARCHAR NOT NULL,
);

CREATE TABLE examination (
  token VARCHAR(6) PRIMARY KEY,
  date_of DATE NOT NULL,
  doctor VARCHAR(10),
  patient VARCHAR(14),
  result VARCHAR NOT NULL,
  type_of BIGINT,
  FOREIGN KEY (type) REFERENCES exam_type(id)
  FOREIGN KEY (med) REFERENCES doctor(code)
  FOREIGN KEY (patient) REFERENCES patient(code)
);