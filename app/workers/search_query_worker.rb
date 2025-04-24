require 'sidekiq-scheduler'
require 'redis'
class SearchQueryWorker
  include Sidekiq::Worker
  WAITING_TIME = 15000 # in milliseconds

  # The perform method takes two arguments, user_id and query,
  # and pushes the query onto a Redis list with a key that includes the user ID.
  def perform
    puts "Sidekiq has started consuming..................."
    users_searches = fetch_users_searches

    return puts "No item at the moment" if users_searches.empty?
    puts "Fetched user searches: #{users_searches.inspect}"
    users_searches.each do |key|
      next unless REDIS.type(key) == "list"

      puts "Key: #{key} => Values: #{REDIS.lrange(key, 0, -1)}"
      consume(key)
    end
    puts "Sidekiq has finished consuming..................."
  end

  private

  def fetch_users_searches
    REDIS.scan_each(match: "user:*").to_a
  end

  def consume(key)
    raw_queries = REDIS.lrange(key, 0, -1)
    return if raw_queries.empty?

    queries = raw_queries.reverse.map { |q| JSON.parse(q) }

    valid_queries = []
    preserved_last = nil

    i = 0
    while i < queries.length - 1
      current = queries[i]
      nxt = queries[i + 1]

      time_diff = nxt["created_at"].to_i - current["created_at"].to_i
      if time_diff >= WAITING_TIME
        valid_queries << current
      end

      i += 1
    end

    # Compare last query to current time
    last_query = queries.last
    time_since_last = DateTime.now.strftime("%Q").to_i - last_query["created_at"].to_i

    if time_since_last >= WAITING_TIME
      valid_queries << last_query
    else
      preserved_last = last_query
    end

    user_id = extract_user_id(key)

    # Insert valid queries
    valid_queries.each do |payload|
      insert_search(user_id, payload)
    end

    # Reset the Redis list:
    REDIS.del(key)
    REDIS.rpush(key, preserved_last.to_json) if preserved_last
  end

  def insert_search(user_id, payload)
    SearchService.insert(user_id, payload)
  end

  def extract_user_id(key)
    key.split(":")[1]
  end

  def right_interval?(time1, time2 = DateTime.now.strftime("%Q"))
    (time2.to_i - time1.to_i).abs.ceil >= 4000
  end
end
