FactoryBot.define do
  factory :player do
    sequence :username do |n|
			"player#{n}"
		end
		password 'password'
		sequence :phone_number do |n|
			"#{n}"
		end
  end
end
