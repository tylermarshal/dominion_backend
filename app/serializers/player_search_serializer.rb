class PlayerSearchSerializer < ActiveModel::Serializer
	attributes :players

	def players
		object.map do |player|
			{id: player.id, username: player.username}
		end
	end
end
