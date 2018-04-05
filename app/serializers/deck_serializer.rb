class DeckSerializer < ActiveModel::Serializer
  attributes :id, :player_id, :draw, :discard, :deck_makeup

  def deck_makeup
    full_deck = []
    full_deck << object.draw
    full_deck << object.discard
    full_deck.flatten.reduce({}) do |result, card_name|
      result[card_name] = 0 if !result[card_name]
      result[card_name] += 1
      result
    end
  end

  def player_id
    object.competitor.player_id
  end
end
