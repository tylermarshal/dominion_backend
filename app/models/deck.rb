class Deck < ApplicationRecord
  belongs_to :competitor
  belongs_to :game

  def self.new_game(competitor_id)
    new(competitor_id: competitor_id,
        draw: starter_deck.shuffle,
        discard: [])
  end

  def self.starter_deck
    deck = []
    7.times {deck.push(32)}
    3.times {deck.push(36)}
    deck
  end
end
