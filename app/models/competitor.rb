class Competitor < ApplicationRecord
  belongs_to :game
  belongs_to :player
  has_one :deck
end
