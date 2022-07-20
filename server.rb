require 'sinatra'
require 'rack/handler/puma'
require 'csv'
require_relative './infra/examination_repo.rb'
require_relative './infra/database_core.rb'

get '/tests' do
  begin
    exam_repo = ExaminationRepo.new(DatabaseCore.get_connection)
    exam_repo.get_all.to_json
  rescue
    halt 500
  end
end

post '/import' do
  begin
    csv = CSV.new(request.body.read, col_sep: ';')
    halt 201 if DatabaseCore.insert_csv(csv)
  rescue
    halt 400
  end
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)
