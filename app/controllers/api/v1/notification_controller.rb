class Api::V1::NotificationController < ApplicationController
	def create
		game = Game.find(params[:id])
		current_player = Game.find(game.current_player)
		game.send_turn_notification(current_player)
	end
end
