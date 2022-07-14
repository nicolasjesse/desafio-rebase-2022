require_relative './infra/database_core.rb'

puts DatabaseCore.populate_tables_from('./data.csv')
