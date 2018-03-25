class Player < ApplicationRecord
  has_many :competitors
  has_many :games, through: :competitors
end
