require "redis"
if Rails.env.test?
  require "mock_redis"
  REDIS = MockRedis.new
elsif Rails.env.production?
  $redis = Redis.new(url: ENV["REDIS_URL"], ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })
else
  redis_config = { url: ENV["REDIS_URL"] || "redis://localhost:6379/0" }
  REDIS = Redis.new(redis_config)
end
