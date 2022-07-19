require_relative './infra/database_core.rb'

desc 'execute database schema'
task :build_schema do
  DatabaseCore.build_tables
end

desc 'populates database from csv file data'
task :populate_from_csv do
  DatabaseCore.populate_tables_from('./csv_data/data.csv')
end

desc 'resets all database tables'
task :reset_database do
  DatabaseCore.drop_tables
  DatabaseCore.build_tables
end