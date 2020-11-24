class Competitor < ApplicationRecord
  belongs_to :user
  has_many :key_figures
end
