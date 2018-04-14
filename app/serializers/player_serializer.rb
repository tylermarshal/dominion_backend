class PlayerSerializer < ActiveModel::Serializer
	attributes :id, :username, :token, :games

	def games
		object.games.map do |game|
			game.id
		end
	end
end
