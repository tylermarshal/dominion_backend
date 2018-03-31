class Deck < ApplicationRecord
  belongs_to :competitor
  belongs_to :player, through: :competitor
  belongs_to :game
end
