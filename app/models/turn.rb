class Turn < ApplicationRecord
  belongs_to :competitor
  belongs_to :game

  def self.record_turn(params)
    game = Game.find(params[:id])
    turn = params["turn"]
    game.update_deck(params["deck"])
		game.update_attacks(params["attack_queue"])
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
    depleted_counter = 0
    game.game_cards.each do |card|
      if card.quantity == 0
        depleted_counter += 1
      end
    end
    if depleted_counter > 2 || game.game_cards.find_by(card_id: Card.find_by(name: "Province").id).quantity == 0
      game.update(status: "complete")
    end
    if game.status == "active"
      game.set_current_player
    else
      game.update(current_player: nil)
      victor_order = game.determine_victor_order
      game.competitors.each do |competitor|
        if competitor.player.token
          NotificationService.send_victory_notification(competitor.player.token, game.id, victor_order)
        end
      end
    end
		turn
  end
end
