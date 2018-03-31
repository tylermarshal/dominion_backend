class GameSerializer < ActiveModel::Serializer
  attributes :game_id, :competitors, :game_cards

  has_many :decks

  def game_id
    object.id
  end

  def competitors
    object.competitors.map do |competitor|
      competitor.id
    end
  end

  def game_cards
    object.game_cards.reduce({}) do |result, game_card|
      result[game_card.card.name] = game_card.quantity
      result
    end
  end
end
