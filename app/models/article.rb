class Article < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search, against: %i[title content], using: { tsearch: { prefix: true, normalization: 8 } }
  validates :title, presence: true
  validates :content, presence: true
end
