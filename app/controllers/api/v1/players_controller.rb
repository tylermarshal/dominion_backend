class Api::V1::PlayersController < ApplicationController
	def create
		new_player = Player.new(user_params)
		if new_player.save
			render json: new_player
		else
			render json: {message: 'Username and Phone Number must be unique'}, status: 400
		end
	ends

	private
		def user_params
			params.permit(:username, :password, :phone_number)
		end
end
