class Turn < ApplicationRecord
  belongs_to :competitor
  belongs_to :game

  def self.record_turn(params)
    game = Game.find(params[:id])
    turn = params["turn"]
    game.update_deck(params["deck"])
		game.update_attacks(params["attack_stack"])
    game.update_game_card_quantities(params['supply'])
    game.update_trash(params['trash'])
    turn = Turn.new(
      game: game,
      competitor_id: game.competitors.find_by(player_id: game.current_player).id,
      coins: turn["coins"],
      cards_played: turn["cards_played"],
      cards_gained: turn["cards_gained"],
      cards_trashed: turn["cards_trashed"]
    )
		game.set_current_player
		turn
  end
end
