class PlayerSerializer < ActiveModel::Serializer
	attributes :id, :username, :token, :active_games, :complete_games, :friends

	def active_games
		object.games.active_games.map do |game|
			{id: game.id, players: game.players.pluck(:username), current: game.current_player_username}
		end
	end

	def complete_games
		object.games.complete_games.map do |game|
			{id: game.id, players: game.players.pluck(:username)}
		end
	end

	def friends
		object.friends.map do |friend|
			{id: friend.id, username: friend.friend.username, player_id: friend.friend.id}
		end
	end
end
