require 'sidekiq'
require 'csv'
require_relative './infra/database_core.rb'

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis:6379' }
end

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis:6379' }
end

class UploadWorker
  include Sidekiq::Worker

  def perform(string)
    csv = CSV.new(string, col_sep: ';')
    DatabaseCore.insert_csv(csv)
  end
end