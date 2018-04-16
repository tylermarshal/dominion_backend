class PlayerSerializer < ActiveModel::Serializer
	attributes :id, :username, :token, :games

	def games
		object.games.map do |game|
			{id: game.id, players: game.players.pluck(:username)}
		end
	end
end
