class TurnSerializer < ActiveModel::Serializer
	attributes :player_id,
						 :coins,
						 :cards_played,
						 :cards_gained,
						 :cards_trashed

	def player_id
		object.competitor.player_id
	end
end
