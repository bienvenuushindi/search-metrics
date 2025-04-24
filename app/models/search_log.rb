class SearchLog < ApplicationRecord
  belongs_to :search_query

  validates :ip_address, presence: true
  validates :results_count, numericality: { only_integer: true }
end
