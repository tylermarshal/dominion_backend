class Api::V1::TurnsController < ApplicationController
  def create
    game = Game.find(params[:id])
    # update decks
    params["decks"].each do |deck_updates|
      deck = game.decks.find(deck_updates["deck_id"])
      deck.draw = deck_updates["draw"]
      deck.discard = deck_updates["discard"]
      deck.save!
    end
    game_cards = game.game_cards
    turn = params["turn"]
    # update game card quantities
    turn["cards_bought"].each do |card|
      game_card = game_cards.find_by(card_id: Card.find_by(name: card).id)
      game_card.update(quantity: (game_card.quantity - 1) )
    end
    # create a new turn
    turn = Turn.new(
      game: game,
      competitor_id: turn["competitor_id"],
      coins: turn["coins"],
      cards_played: turn["cards_played"],
      cards_bought: turn["cards_bought"]
    )
    if turn.save!
      render status: 200
    end
  end
end
