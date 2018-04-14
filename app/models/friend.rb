class Friend < ApplicationRecord
  belongs_to :player
	belongs_to :friend, :class_name => "Player"
end
