require_relative './infra/database_core.rb'

DatabaseCore.populate_tables_from('./data.csv')
