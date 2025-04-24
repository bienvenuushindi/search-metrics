class SearchQuery < ApplicationRecord
  has_many :search_logs
  validates :query, presence: true, uniqueness: true

  def self.track(query)
    query = query.downcase
    search_query = find_or_initialize_by(query: query)
    search_query.count ||= 0
    search_query.count += 1
    search_query.save!
    search_query
  end

  def log_search(ip, payload)
    search_logs.create!(
      ip_address: ip,
      results_count: payload["results_count"],
      created_at: payload["created_at"]
    )
  end
end
