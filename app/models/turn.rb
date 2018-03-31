class Turn < ApplicationRecord
  belongs_to :competitors
  belongs_to :player, through: :competitor
  belongs_to :game

  
end
