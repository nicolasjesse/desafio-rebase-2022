require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis:6379' }
end

require 'sidekiq/web'
use Rack::Session::Cookie, :key => 'rack.session',
  :expire_after => 2592000,
  :secret => 'change_me'
run Sidekiq::Web