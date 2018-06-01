class Api::V1::NotificationController < ApplicationController
	def create
		game = Game.find(params[:id])
		current_player = Player.find(game.current_player)
		last_poke = game.last_poke
		last_poke = Time.now + 8.hours if last_poke.nil?
		if (Time.now - last_poke).seconds >= (3600 * 8)
			game.send_turn_notification(current_player)
			game.update(last_poke: Time.now)
		end
		render status: 200
	end
end
