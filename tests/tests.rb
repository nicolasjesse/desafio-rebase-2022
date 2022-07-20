require 'test/unit'
require 'rake'
require 'csv'
require_relative '../infra/database_core.rb'
require_relative '../infra/examination_repo.rb'


class DatabaseCoreTest < Test::Unit::TestCase
  def setup
    DatabaseCore.drop_tables(DatabaseCore.get_connection('test-db'))
    DatabaseCore.build_tables(DatabaseCore.get_connection('test-db'))
  end

  def test_connection
    conn = DatabaseCore.get_connection('test-db')

    assert_equal conn.class, PG::Connection
  end

  def test_build_tables
    conn = DatabaseCore.get_connection('test-db')
    DatabaseCore.drop_tables(conn)
    method_result = DatabaseCore.build_tables(conn)
    tables = conn.exec('SELECT * FROM information_schema.tables;')
    public_table_names = tables.values.select { |all_tables| all_tables.include?("public") }.map { |public_tables| public_tables[2] }

    assert public_table_names.include?("examination")
    assert method_result
  end

  def test_drop_tables
    conn = DatabaseCore.get_connection('test-db')

    DatabaseCore.drop_tables(conn)
    tables = conn.exec('SELECT * FROM information_schema.tables;')
    public_table_names = tables.values.select { |all_tables| all_tables.include?("public") }.map { |public_tables| public_tables[2] }

    assert !public_table_names.include?("examination")
  end

  def test_insert_csv
    conn = DatabaseCore.get_connection('test-db')
    csv = CSV.read('./csv_data/test-data.csv', col_sep: ';')
    result_before = conn.exec('SELECT * FROM examination;').values
    DatabaseCore.insert_csv(csv, conn)
    result_after = conn.exec('SELECT * FROM examination;').values

    assert (result_after.length - result_before.length) == 2
  end

  def test_populate_tables_from_csv
    conn = DatabaseCore.get_connection('test-db')
    result = DatabaseCore.populate_tables_from('./csv_data/test-data.csv', conn)
    values = conn.exec('SELECT * FROM examination;').values

    assert_equal values.length, 2
    assert_equal values[0][1], 'ABCD12'
    assert_equal values[1][1], 'ABCD34'
  end
end

class ExaminationRepoTest < Test::Unit::TestCase
  def setup
    DatabaseCore.drop_tables(DatabaseCore.get_connection('test-db'))
    DatabaseCore.build_tables(DatabaseCore.get_connection('test-db'))
  end

  def test_create
    conn = DatabaseCore.get_connection('test-db')
    exam_repo = ExaminationRepo.new(conn)
    examination = ['048.973.170-88', 'Emilly Batista Neto', 'geraldo.crona@ebert-quigley.com',
                   '2001-03-11', '165 Rua Rafaela', 'Ituverava', 'Alagoas', 'C000BJ20J4', 'PI',
                   'Maria Luiza Pires', 'dinna@wisozk.biz', 'DGET56', '2021-08-05', 'hemácias',
                   '45-52', '97']
    result = exam_repo.create(examination)

    db_assertion = conn.exec("SELECT * FROM examination WHERE token='DGET56'").values[0]

    assert db_assertion.include?("dinna@wisozk.biz")
    assert db_assertion.include?("geraldo.crona@ebert-quigley.com")
    assert db_assertion.include?("C000BJ20J4")
    assert result
  end

  def test_get_all
    conn = DatabaseCore.get_connection('test-db')
    exam_repo = ExaminationRepo.new(conn)
    examination1 = ['048.973.170-33', 'Emillo Batista Neto', 'geralda.crona@ebert-quigley.com',
      '2001-03-11', '165 Rua Rafaela', 'Ituverava', 'Alagoas', 'C001BJ20J4', 'PB',
      'Maria Luiza Pires', 'donno@wisozk.biz', 'PKDG94', '2021-08-05', 'hemácias',
      '45-52', '97']
    examination2 = ['049.623.830-27', 'Janaina Pereira', 'antonio@email.com',
      '1999-09-16', '14 Rua José', 'Atiguitinga', 'Roraima', 'B123BJ20J4', 'RO',
      'Teo Lopes', 'talla@ponto.biz', 'DABC56', '2021-08-08', 'hemácias',
      '45-52', '68']

    result_before = exam_repo.get_all
    exam_repo.create(examination1)
    exam_repo.create(examination2)
    result_after = exam_repo.get_all
    result_tokens = result_after.map { |row| row[1] }
    
    assert result_tokens.include?('PKDG94')
    assert result_tokens.include?('DABC56')
    assert (result_after.length - result_before.length) == 2
  end
end
