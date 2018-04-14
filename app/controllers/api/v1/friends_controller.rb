class Api::V1::FriendsController < ApplicationController
	def create
		friendship = Friend.new(friend_params)
		if friendship.save
			render json: friendship
		else
			render json: {message: 'Friendship could not be saved'}, status: 400
		end
	end

	private
		def friend_params
			params.permit(:player_id, :friend_id)
		end
end
