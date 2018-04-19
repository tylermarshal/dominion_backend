class Api::V1::FriendsController < ApplicationController
	def show
		friend = Friend.find(friend_params[:id])
		if friend
			render json: friend
		else
			render json: {message: 'Friendship could not be saved'}, status: 400
		end
	end

	def create
		friend = Player.find_by(username: friend_params[:friend_name])
		if friend
			friendship = Friend.new(player_id: friend_params[:player_id], friend_id: friend.id)
			if friendship.save
				render json: friendship
			end
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
			params.permit(:id, :player_id, :friend_name, :friend_id)
		end
end
