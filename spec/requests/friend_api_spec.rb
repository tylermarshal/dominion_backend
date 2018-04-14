require 'rails_helper'

describe('Friend API') do
	before(:each) do
		DatabaseCleaner.clean
	end

	after(:all) do
		DatabaseCleaner.clean
	end

	context('POST friend') do
		it "can add a friend to a player" do
			player_1 = create(:player)
			player_2 = create(:player)
			params = {player_id: player_1.id, friend_id: player_2.id}

			post '/api/v1/friends', params: params.to_json, headers: {"CONTENT_TYPE" => 'application/json', 'ACCEPT' => 'application/json'}

			expect(response).to be_success
			new_friend = JSON.parse(response.body, symbolize_names: true)

			expect(new_friend[:username]).to eq(player_2.username)
			expect(new_friend[:id]).to eq(player_2.id)
		end

		it "fails to add a friend because of an incorrect id" do
			player_1 = create(:player)

			params = {player_id: player_1.id, friend_id: nil}

			post '/api/v1/friends', params: params.to_json, headers: {"CONTENT_TYPE" => 'application/json', 'ACCEPT' => 'application/json'}

			response_body = JSON.parse(response.body, symbolize_names: true)
			expect(response.status).to eq(400)
			expect(response_body[:message]).to eq('Friendship could not be saved')
		end
	end

	context('DELETE friend') do

	end
end
