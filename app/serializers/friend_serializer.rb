class FriendSerializer < ActiveModel::Serializer
	attributes :id, :username, :player_id, :games_played

	def username
		object.friend.username
	end

	def player_id
		object.friend.id
	end

	def games_played
		object.games_played
	end
end
