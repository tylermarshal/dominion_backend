class Turn < ApplicationRecord
  belongs_to :competitors
  belongs_to :game
end
