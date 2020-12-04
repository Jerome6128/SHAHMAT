class Competitor < ApplicationRecord
  belongs_to :company
  has_many :messages, dependent: :destroy

  has_one_attached :photo
  has_many :key_figures, dependent: :destroy
  has_many :job_offers, dependent: :destroy

  include PgSearch::Model
  pg_search_scope :search_by_brand_name_and_siren,
    against: [ :brand_name, :siren ],
    using: {
      tsearch: { prefix: true }
    }

  def today?
    created_at.to_date == Date.today
  end
end
