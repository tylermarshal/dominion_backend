class DeckSerializer < ActiveModel::Serializer
  attributes :id, :competitor_id, :draw, :discard, :deck_makeup

  def deck_makeup
    full_deck = []
    full_deck << object.draw
    full_deck << object.discard
    full_deck.flatten.reduce({}) do |result, card_id|
      result[card_id] = 0 if !result[card_id]
      result[card_id] += 1
      result
    end
  end
end
