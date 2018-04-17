class PlayerSerializer < ActiveModel::Serializer
	attributes :id, :username, :token, :active_games, :complete_games, :friends

	def active_games
		object.games.map do |game|
			if game.status == "active"
				{id: game.id, players: game.players.pluck(:username), current: game.current_player_username}
			end
		end
	end

	def complete_games
		object.games.map do |game|
			if game.status == "complete"
				{id: game.id, players: game.players.pluck(:username), current: game.current_player_username}
			end
		end
	end

	def friends
		object.friends.map do |friend|
			{id: friend.friend.id, username: friend.friend.username}
		end
	end
end
