require 'sinatra'
require 'rack/handler/puma'
require 'csv'
require_relative './infra/examination_repo.rb'
require_relative './infra/database_core.rb'

get '/tests' do
  exam_repo = ExaminationRepo.new(DatabaseCore.get_connection)
  exam_repo.get_all.values.to_json
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)
