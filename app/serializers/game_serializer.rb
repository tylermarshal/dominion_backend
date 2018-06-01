class GameSerializer < ActiveModel::Serializer
  attributes :game_id,
						 :players,
						 :competitors,
						 :game_cards,
						 :trash,
						 :status,
						 :current_player,
						 :current_player_username,
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

	def current_player_username
		if object.status == 'active'
			Player.find(object.current_player).username
		end
	end

	def attack_queue
		object.competitors.reduce({}) do |result, competitor|
      result[competitor.player_id] = competitor.attacks
			result
    end
	end

  def score
    object.score
  end
end
