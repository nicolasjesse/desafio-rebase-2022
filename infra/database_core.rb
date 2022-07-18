require 'pg'
require 'csv'
require_relative 'examination_repo.rb'

class DatabaseCore
  def self.get_connection(database = 'exam-db')
    PG::Connection.open(dbname: 'hospital', user: 'exam',
                        password: 'exam', host: database)
  end

  def self.create_or_recreate_tables(connection)
    begin
      schema = "CREATE TABLE examination (
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
      );"
      connection.exec(schema)
      return true
    rescue PG::DuplicateTable
      connection.exec('DROP TABLE IF EXISTS examination')
      self.create_or_recreate_tables(connection)
    rescue
      return false
    end
  end

  def self.populate_tables_from(csv, connection)
    begin
      self.create_or_recreate_tables(connection)
      exam_repo = ExaminationRepo.new(connection)
      CSV.read(csv, col_sep: ';').drop(1).each do |row|
        exam_repo.create(row)
      end
      return true
    rescue
      return false
    end
  end
end
