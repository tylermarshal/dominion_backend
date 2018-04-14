class PlayerSerializer < ActiveModel::Serializer
	attributes :id, :username, :token
end
