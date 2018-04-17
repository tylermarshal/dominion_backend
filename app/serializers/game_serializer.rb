class GameSerializer < ActiveModel::Serializer
  attributes :game_id,
						 :players,
						 :competitors,
						 :game_cards,
						 :trash,
						 :status,
						 :current_player,
						 :turn_order,
						 :attack_queue,
             :score


  has_many :decks
  has_many :turns


  def game_id
    object.id
  end

	def players
		object.players.pluck(:username)
	end

  def competitors
    object.players.pluck(:id)
  end

  def game_cards
    object.game_cards.reduce({}) do |result, game_card|
      result[game_card.card.name.downcase] = game_card.quantity
      result
    end
  end

	def attack_queue
		object.competitors.reduce({}) do |result, competitor|
      result[competitor.player_id] = competitor.attacks
			result
    end
	end

  def score
    object.competitors.reduce(Hash.new(0)) do |result, competitor|
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

  VICTORY_CARDS = {
    'estate' => 1,
    'duchy' => 3,
    'province' => 6
  }
end
