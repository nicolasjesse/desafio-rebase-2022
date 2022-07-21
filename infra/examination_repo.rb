class ExaminationRepo
  def initialize(conn)
    @conn = conn
  end

  def create(examination)
    begin
      raise if examination.length != 16
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

  def get_by_token(token)
    begin
      result = @conn.exec("SELECT * FROM examination WHERE token='#{token}'").values
      tests = result.map do |test|
        { type: test[14],
          limits: test[15],
          result: test[16]
        }
      end
      { result_token: token, 
        result_date: result[0][13],
        cpf: result[0][6],
        name: result[0][7],
        email: result[0][4],
        birthday: result[0][9],
        doctor: {
          crm: result[0][2],
          crm_state: result[0][5],
          name: result[0][3]
        },
        tests: tests
      }
    rescue => exception
      raise exception
    end
  end

  def get_all
    begin
      result = @conn.exec("SELECT * FROM examination;")
      result.values
    rescue => exception
      raise exception
    end
  end
end
