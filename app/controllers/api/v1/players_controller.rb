class Api::V1::PlayersController < ApplicationController
	def index
		players = Player.where('username LIKE ?', "%#{search_params[:user_query]}%")
		render json: players, serializer: PlayerSearchSerializer
	end

	def show
		player = Player.find_by(username: user_params[:username])
		if player && player.authenticate(user_params[:password])
			render json: player
		else
			render json: {message: 'User could not be found'}, status: 400
		end
	end

	def create
		new_player = Player.new(user_params)
		if new_player.save
			render json: new_player
		else
			render json: {message: 'Username and Phone Number must be unique'}, status: 400
		end
	end

	private
		def user_params
			params.permit(:username, :password, :phone_number)
		end

		def search_params
			params.permit(:user_query)
		end
end
