require 'sinatra'
require 'rack/handler/puma'
require 'csv'
require_relative './infra/examination_repo.rb'
require_relative './infra/database_core.rb'

get '/tests' do
  begin
    exam_repo = ExaminationRepo.new(DatabaseCore.get_connection)
    exam_repo.get_all.values.to_json
  rescue
    halt 500
  end
end

post '/import' do
  begin
    csv = CSV.new(request.body.read, col_sep: ';')
    DatabaseCore.insert_csv_into_database(csv, DatabaseCore.get_connection)
    halt 201
  rescue
    halt 400
  end
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)
