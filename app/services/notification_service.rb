class NotificationService
	def self.send_notification(token, game_id)
		client = Exponent::Push::Client.new
		message = [{
			to: token,
			title: 'Dominion with Friends',
			body: "It's your turn in Game #{game_id}"
		}]

		client.publish message
	end

end
