class GameCard < ApplicationRecord
  belongs_to :game
  belongs_to :card

  def self.new_game
    game_cards = [
      #copper
      GameCard.new(card_id: 32, quantity: 40),
      #curse
      GameCard.new(card_id: 33, quantity: 10),
      #silver
      GameCard.new(card_id: 39, quantity: 30),
      #gold
      GameCard.new(card_id: 62, quantity: 30),
      #estate
      GameCard.new(card_id: 36, quantity: 10),
      #duchy
      GameCard.new(card_id: 54, quantity: 10),
      #provice
      GameCard.new(card_id: 63, quantity: 10)
    ]
    kingdom_cards = Card.kingdom.sample(10)
    kingdom_cards.each do |kingdom_card|
      game_cards << GameCard.new(card_id: kingdom_card.id, quantity: 10)
    end
    game_cards
  end
end
