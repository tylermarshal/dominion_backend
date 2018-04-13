class GameSerializer < ActiveModel::Serializer
  attributes :game_id,
						 :competitors,
						 :game_cards,
						 :trash,
						 :status,
						 :current_player,
						 :turn_order,
						 :attack_queue

  has_many :decks

  def game_id
    object.id
  end

  def competitors
    object.competitors.map do |competitor|
      competitor.player_id
    end
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
end
