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
task :reset_database, [:db] do |t, args|
  args.with_defaults(:db => 'med-db')
  DatabaseCore.drop_tables(DatabaseCore.get_connection(args[:db]))
  DatabaseCore.build_tables(DatabaseCore.get_connection(args[:db]))
end