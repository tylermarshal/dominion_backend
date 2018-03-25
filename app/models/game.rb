class Game < ApplicationRecord
  has_many :game_cards
  has_many :decks
  has_many :competitors
  has_many :players, through: :competitors
end
