class GameCard < ApplicationRecord
  belongs_to :game
  belongs_to :card

  def self.new_game
    game_cards = [
      #copper
      GameCard.new(card_id: Card.find_by(name: 'copper').id, quantity: 40),
      #curse
      GameCard.new(card_id: Card.find_by(name: 'curse').id, quantity: 10),
      #silver
      GameCard.new(card_id: Card.find_by(name: 'silver').id, quantity: 30),
      #gold
      GameCard.new(card_id: Card.find_by(name: 'gold').id, quantity: 30),
      #estate
      GameCard.new(card_id: Card.find_by(name: 'estate').id, quantity: 10),
      #duchy
      GameCard.new(card_id: Card.find_by(name: 'duchy').id, quantity: 10),
      #provice
      GameCard.new(card_id: Card.find_by(name: 'province').id, quantity: 10)
    ]
    kingdom_cards = Card.kingdom.where(set: :dominion).sample(10)
    kingdom_cards.each do |kingdom_card|
      game_cards << GameCard.new(card_id: kingdom_card.id, quantity: 10)
    end
    game_cards
  end
end
