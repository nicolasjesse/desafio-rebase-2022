require 'sinatra'
require 'rack/handler/puma'
require 'csv'
require_relative './infra/examination_repo.rb'

get '/tests' do
  exam_repo = ExaminationRepo.new
  exam_repo.get_all.values.to_json
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)
