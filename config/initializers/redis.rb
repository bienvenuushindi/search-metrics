url = ENV["REDISCLOUD_URL"] || ENV["REDIS_URL"]
Sidekiq.configure_server do |config|
  config.redis = { url: url }
end
Sidekiq.configure_client do |config|
  config.redis = { url: url }
end
$redis = Redis.new(url: url)
