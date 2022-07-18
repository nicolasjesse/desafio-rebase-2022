class ExaminationRepo
  def initialize(conn)
    @conn = conn
  end

  def create(examination)
    begin
      @conn.exec_params("INSERT INTO examination (
        patient_code, patient_name,
        patient_email, patient_birth_date,
        patient_street, patient_city,
        patient_state, doctor_code,
        doctor_state_code, doctor_name,
        doctor_email, token,
        date, type,
        type_limit, result )
        VALUES (
          $1, $2, $3, $4, $5, $6, $7, $8,
          $9, $10, $11, $12, $13, $14, $15, $16
        );", examination )
      return true
    rescue
      return false
    end
  end

  def get_all
    begin
      result = @conn.exec("SELECT * FROM examination;")
    rescue => exception
      raise exception
    ensure
      [] unless result
    end
  end
end