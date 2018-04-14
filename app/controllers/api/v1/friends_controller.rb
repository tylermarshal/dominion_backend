class Api::V1::FriendsController < ApplicationController
	def create
		friendship = Friend.new(friend_params)
		if friendship.save
			render json: friendship.friend
		else
			render json: {message: 'Friendship could not be saved'}, status: 400
		end
	end

	def delete
		friendship = Friend.where(
			'player_id = ? AND friend_id = ?',
			friend_params[:player_id],
			friend_params[:friend_id]).first
		if friendship
			friendship.destroy
			render json: {message: 'Friendship deleted'}
		else
			render json: {message: 'Friendship could not be deleted'}, status: 400
		end
	end

	private
		def friend_params
			params.permit(:player_id, :friend_id)
		end
end
