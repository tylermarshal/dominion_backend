class Game < ApplicationRecord
  has_many :game_cards
  has_many :cards, through: :game_cards
  has_many :decks
  has_many :competitors
  has_many :players, through: :competitors
  has_many :turns

  after_save :create_decks

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
end
