class Game < ApplicationRecord
  has_many :game_cards
  has_many :cards, through: :game_cards
  has_many :decks
  has_many :competitors
  has_many :players, through: :competitors
  has_many :turns

  after_save :create_decks

  enum status: [:active, :complete]

  scope :active_games, -> { where(status: 'active') }
  scope :complete_games, -> { where(status: 'complete') }

  def self.new_game(players)
    new_game = Game.new(trash: [])
    if Player.exists?(id: players)
      new_game.current_player = players.first
      new_game.turn_order = players
      players.each do |player_id|
        player = Player.find(player_id)
        new_game.players << player
      end
      new_game.game_cards << GameCard.new_game(players)
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

  def update_deck(deck_updates)
    deck = decks.find_by(competitor_id: competitors.find_by(player_id: current_player).id)
    deck.update(
      draw: deck_updates["draw"],
      discard: deck_updates["discard"]
    )
  end

	def update_attacks(attacks)
		attacks.each do |attack|
			competitors.find_by(player_id: attack).update(attacks: attacks[attack])
		end
	end

  def update_game_card_quantities(supply)
    supply.each do |card|
      game_card = game_cards.find_by(card_id: Card.find_by(name: card).id)
      game_card.update(quantity: supply[card])
    end
  end

  def update_trash(trashed_cards)
    update(trash: trashed_cards)
  end

	def set_current_player
		next_player = Player.find(turn_order[(turns.count + 1) % competitors.count].to_i)
		send_turn_notification(next_player)
		update(current_player: next_player.id)
	end

	def send_turn_notification(player)
		if player.token
			NotificationService.send_turn_notification(player.token, id)
		end
	end

	def current_player_username
		Player.find(current_player).username
	end

  def score
    competitors.reduce(Hash.new(0)) do |result, competitor|
      full_deck = competitor.deck.draw + competitor.deck.discard
      result[competitor.player.username] = 0
      full_deck.each do |card|
        if VICTORY_CARDS[card]
          result[competitor.player.username] += VICTORY_CARDS[card]
        end
      end
      result
    end
  end

  def determine_victor_order
    score.sort_by do |username, player_score|
      player_score
    end.reverse
  end

  VICTORY_CARDS = {
    'estate' => 1,
    'duchy' => 3,
    'province' => 6,
		'curse' => -1
  }
end
