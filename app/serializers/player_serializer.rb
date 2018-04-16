class PlayerSerializer < ActiveModel::Serializer
	attributes :id, :username, :token, :games, :friends

	def games
		object.games.map do |game|
			{id: game.id, players: game.players.pluck(:username)}
		end
	end

	def friends
		object.friends.map do |friend|
			{id: friend.friend.id, username: friend.friend.username}
		end
	end
end
