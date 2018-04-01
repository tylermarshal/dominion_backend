class Game < ApplicationRecord
  has_many :game_cards
  has_many :cards, through: :game_cards
  has_many :decks
  has_many :competitors
  has_many :players, through: :competitors
  has_many :turns

  after_save :create_decks

  enum status: [:active, :complete]

  def self.new_game(players)
    new_game = Game.new
    if Player.exists?(id: players)
      players.each do |player_id|
        player = Player.find(player_id)
        new_game.players << player
      end
      new_game.game_cards << GameCard.new_game
    end
    new_game
  end

  def create_decks
    if decks.count == 0
      competitors.each do |competitor|
        decks << Deck.new_game(competitor.id)
      end
    end
  end

  def update_decks(deck_changes)
    deck_changes.each do |deck_updates|
      deck = decks.find(deck_updates["deck_id"])
      deck.update(
        draw: deck_updates["draw"],
        discard: deck_updates["discard"]
      )
    end
  end

  def update_game_card_quantities(cards_gained)
    cards_gained.each do |card|
      game_card = game_cards.find_by(card_id: Card.find_by(name: card).id)
      game_card.update(quantity: (game_card.quantity - 1) )
    end
  end

  def update_trash(trashed_cards)
    trashed_cards.each do |card|
      trash << card
    end
  end
end
