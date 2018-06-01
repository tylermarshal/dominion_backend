class Api::V1::NotificationController < ApplicationController
	def create
		game = Game.find(params[:id])
		current_player = Player.find(game.current_player)
		if current_player.token
			game.send_turn_notification(current_player)
		end
		render status: 200
	end
end
