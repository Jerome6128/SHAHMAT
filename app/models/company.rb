class Company < ApplicationRecord
  has_many :users
  has_many :competitors
  has_many :messages, through: :users
end
