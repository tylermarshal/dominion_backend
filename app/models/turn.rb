class Turn < ApplicationRecord
  belongs_to :competitor
  belongs_to :game
end
