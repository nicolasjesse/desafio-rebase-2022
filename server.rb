require 'sinatra'
require 'rack/handler/puma'
require_relative './upload_worker.rb'
require_relative './infra/examination_repo.rb'
require_relative './infra/database_core.rb'

get '/tests' do
  begin
    exam_repo = ExaminationRepo.new(DatabaseCore.get_connection)
    exam_repo.get_all.to_json
  rescue
    { message: 'Something happened, try again' }.to_json
    halt 500
  end
end

get '/tests/:token' do |token|
  begin
    exam_repo = ExaminationRepo.new(DatabaseCore.get_connection)
    body exam_repo.get_by_token(token).to_json
    halt 200
  rescue => exception
    halt 404, { message: 'Not Found' }.to_json
  end
end

post '/import' do
  begin
    UploadWorker.perform_async(request.body.read)
    halt 201, { message: 'Imported sucessfully' }.to_json
  rescue
    halt 400, { message: 'Invalid CSV format' }.to_json
  end
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)
