url = ENV["REDISCLOUD_URL"] || ENV["REDIS_URL"]
Sidekiq.configure_server do |config|
  config.redis = { url: url }
end
Sidekiq.configure_client do |config|
  config.redis = { url: url }
end
REDIS = Redis.new(url: url, ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })
$redis = REDIS
