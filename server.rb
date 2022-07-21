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
    halt 500
  end
end

post '/import' do
  begin
    halt 201 if UploadWorker.perform_async(request.body.read)
  rescue
    halt 400
  end
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)
