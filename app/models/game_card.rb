class GameCard < ApplicationRecord
  belongs_to :game
  belongs_to :card

  def self.new_game(players)
    game_cards = [
      GameCard.new(card_id: Card.find_by(name: 'copper').id, quantity: (60 - players.count * 7)),
      GameCard.new(card_id: Card.find_by(name: 'curse').id, quantity: ((players.count - 1) * 10)),
      GameCard.new(card_id: Card.find_by(name: 'silver').id, quantity: 40),
      GameCard.new(card_id: Card.find_by(name: 'gold').id, quantity: 30),
      GameCard.new(card_id: Card.find_by(name: 'estate').id, quantity: victory_cards(players.count)),
      GameCard.new(card_id: Card.find_by(name: 'duchy').id, quantity: victory_cards(players.count)),
      GameCard.new(card_id: Card.find_by(name: 'province').id, quantity: victory_cards(players.count))
    ]
    kingdom_cards = Card.kingdom.where(set: :dominion).sample(10)
    kingdom_cards.each do |kingdom_card|
      game_cards << GameCard.new(card_id: kingdom_card.id, quantity: 10)
    end
    game_cards
  end
end

def victory_cards(player_count)
  return 12 if player_count > 2
  return 8
end
