# frozen_string_literal: true

class SearchService
  class << self
    def push_to_redis(redis, query)
      redis.lpush(
        "user:#{query[:creator]}",
        {
          query: query[:value],
          results_count: query[:results_count],
          created_at: DateTime.now.strftime('%Q')
        }.to_json
      )
    end


    def insert(user_id, payload)
      search_query = SearchQuery.track(payload["query"])
      search_query.log_search(user_id, payload)
    end
  end
end
