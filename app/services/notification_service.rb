class NotificationService

	def self.send_turn_notification(token, game_id)
		client = Exponent::Push::Client.new
		message = [{
			to: token,
			title: 'Dominion with Friends',
			body: "It's your turn in Game #{game_id}",
			data: {id: game_id}
		}]

		client.publish message
	end

	def self.send_victory_notification(token, game_id, victor_order)
		client = Exponent::Push::Client.new
		message_body = "Game #{game_id} has ended!"
		victor_order.each_with_index do |player, place|
			message_body += " #{(place+1).ordinalize}: #{player[0]} - #{player[1]} points."
		end
		message = [{
			to: token,
			title: 'Dominion with Friends',
			body: message_body,
			data: {id: game_id}
		}]

		client.publish message
	end

end
