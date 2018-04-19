class Friend < ApplicationRecord
  belongs_to :player
	belongs_to :friend, :class_name => "Player"

	validates_uniqueness_of :friend_id, :scope => [:player_id]

	def common_games
		player.games.joins(:competitors).joins(:players).where('players.id = ?', friend_id)
	end

	def games_played
		common_games.count
	end
end
