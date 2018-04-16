class Player < ApplicationRecord
	has_secure_password
	validates_uniqueness_of :username, :phone_number
  has_many :competitors
  has_many :games, through: :competitors
	has_many :friends
end
