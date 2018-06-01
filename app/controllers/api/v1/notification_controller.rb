class Api::V1::NotificationController < ApplicationController
	def create
		game = Game.find(params[:id])
		game.send_turn_notification(game.current_player)
	end
end
