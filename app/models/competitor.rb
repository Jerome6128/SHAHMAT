class Competitor < ApplicationRecord
  belongs_to :user

  include PgSearch::Model
  pg_search_scope :search_by_brand_name_and_siren,
    against: [ :brand_name, :siren ],
    using: {
      tsearch: { prefix: true }
    }
end
