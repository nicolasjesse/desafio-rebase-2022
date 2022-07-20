require 'pg'
require 'csv'
require_relative 'examination_repo.rb'

class DatabaseCore
  def self.get_connection(database='med-db')
    PG::Connection.open(dbname: 'hospital', user: 'exam', password: 'exam', host: database)
  end

  def self.drop_tables(connection=self.get_connection)
    begin
      connection.exec('DROP TABLE IF EXISTS examination')
      return true
    rescue => exception
      raise exception
    end
  end

  def self.build_tables(connection=self.get_connection)
    begin
      database_schema = IO.read(File.expand_path File.dirname(__FILE__) + '/schema/base_schema.sql')
      connection.exec(database_schema)
      return true
    rescue => exception
      raise exception
    end
  end

  def self.insert_csv(csv, connection=self.get_connection)
    begin
      exam_repo = ExaminationRepo.new(connection)
      csv.each_with_index do |row, i|
        next if i == 0
        raise unless exam_repo.create(row)
      end
      return true
    rescue => exception
      raise exception
    end
  end

  def self.populate_tables_from(csv_path, connection=self.get_connection)
    begin
      exam_repo = ExaminationRepo.new(connection)
      CSV.read(csv_path, col_sep: ';').each_with_index do |row, i|
        next if i == 0
        exam_repo.create(row)
      end
      return true
    rescue => exception
      raise exception
    end
  end
end
