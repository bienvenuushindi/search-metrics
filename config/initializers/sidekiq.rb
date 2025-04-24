if Rails.env.production?
  Sidekiq.configure_server do |config|
    config.redis = {
      url: ENV["REDIS_URL"],
      ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
    }
  end

  Sidekiq.configure_client do |config|
    config.redis = {
      url: ENV["REDIS_URL"],
      ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
    }
  end

else
  redis_config = { url: ENV["REDIS_URL"] || "redis://localhost:6379/0" }
  Sidekiq.configure_server do |config|
    config.redis = if Rails.env.test?
                     REDIS
                   else
                     redis_config
                   end
  end

  Sidekiq.configure_client do |config|
    config.redis = redis_config
  end
end
