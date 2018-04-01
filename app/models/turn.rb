class Turn < ApplicationRecord
  belongs_to :competitor
  belongs_to :game

  def self.record_turn(params)
    game = Game.find(params[:id])
    turn = params["turn"]
    game.update_decks(params["decks"])
    game.update_game_card_quantities(turn['cards_gained'])
    turn = Turn.new(
      game: game,
      competitor_id: turn["competitor_id"],
      coins: turn["coins"],
      cards_played: turn["cards_played"],
      cards_gained: turn["cards_gained"],
      cards_trashed: turn["cards_trashed"]
    )
  end
end
