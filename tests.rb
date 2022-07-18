require 'test/unit'
require_relative './infra/database_core.rb'

class DatabaseCoreTest < Test::Unit::TestCase
  def test_connection
    conn = DatabaseCore.get_connection('test-db')

    assert_equal conn.class, PG::Connection
  end

  def test_create_or_recreate_tables_if_table_dont_exists
    conn = DatabaseCore.get_connection('test-db')
    method_result = DatabaseCore.create_or_recreate_tables(conn)
    tables = conn.exec('SELECT * FROM information_schema.tables;')
    public_table_names = tables.values.select { |all_tables| all_tables.include?("public") }.map { |public_tables| public_tables[2] }

    assert public_table_names.include?("examination")
    assert_equal method_result, true
  end

  def test_create_or_recreate_tables_if_table_exists
    conn = DatabaseCore.get_connection('test-db')
    DatabaseCore.create_or_recreate_tables(conn)
    method_result = DatabaseCore.create_or_recreate_tables(conn)
    tables = conn.exec('SELECT * FROM information_schema.tables;')
    public_table_names = tables.values.select { |all_tables| all_tables.include?("public") }.map { |public_tables| public_tables[2] }

    assert public_table_names.include?("examination")
    assert_equal method_result, true
  end

  def test_populate_tables_from_csv
    conn = DatabaseCore.get_connection('test-db')
    result = DatabaseCore.populate_tables_from('./test-data.csv', conn)
    values = conn.exec('SELECT * FROM examination;').values

    assert_equal values.length, 2
    assert_equal values[0][1], 'IQCZ17'
    assert_equal values[1][1], 'IQCZ17'
  end
end