class Competitor < ApplicationRecord
  belongs_to :user
  has_many :key_figures
  has_many :job_offers
end
