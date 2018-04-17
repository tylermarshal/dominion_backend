require 'rails_helper'

describe('Player API') do
	before(:each) do
		DatabaseCleaner.clean
	end

	context('POST player') do
		it('creates a new player') do
			params = {
				username: 'Lord Rattington',
				password: 'password',
				phone_number: '9999999999'
			}

			post "/api/v1/signup", params: params.to_json, headers: {"CONTENT_TYPE" => 'application/json', 'ACCEPT' => 'application/json'}

			expect(response).to be_success
			new_player = JSON.parse(response.body, symbolize_names: true)
			last_player = Player.last

			expect(new_player[:id]).to eq(last_player.id)
			expect(new_player[:username]).to eq(last_player.username)
			expect(new_player[:token]).to be_nil
			expect(new_player[:games]).to be_empty
		end

		it('username is not unique') do
			create(:player, username: 'Lord Rattington')
			params = {username: 'Lord Rattington', password: 'password', phone_number: '9999999999'}

			post "/api/v1/signup", params: params.to_json, headers: {"CONTENT_TYPE" => 'application/json', 'ACCEPT' => 'application/json'}

			response_body = JSON.parse(response.body, symbolize_names: true)

			expect(response.status).to eq(400)
			expect(response_body[:message]).to eq('Username and Phone Number must be unique')
		end

		it('phone number is not unique') do
			create(:player, phone_number: '9999999999')
			params = {username: 'Lord Rattington', password: 'password', phone_number: '9999999999'}

			post "/api/v1/signup", params: params.to_json, headers: {"CONTENT_TYPE" => 'application/json', 'ACCEPT' => 'application/json'}

			response_body = JSON.parse(response.body, symbolize_names: true)

			expect(response.status).to eq(400)
			expect(response_body[:message]).to eq('Username and Phone Number must be unique')
		end
	end

	context('GET player by credentials') do
		it('can retrieve player with correct credentials') do
			player = create(:player, username: 'Lord Rattington', phone_number: '9999999999', password: 'password')
			params = {username: 'Lord Rattington', password: 'password'}

			get "/api/v1/login", params: params, headers: {"CONTENT_TYPE" => 'application/json', 'ACCEPT' => 'application/json'}

			response_body = JSON.parse(response.body, symbolize_names: true)

			expect(response.status).to eq(200)
			expect(response_body[:id]).to eq(player.id)
			expect(response_body[:username]).to eq(player.username)
			expect(response_body[:token]).to eq(player.token)
		end

		it('can retrieve player, see their games and friends') do
			player = create(:player, username: 'Lord Rattington', phone_number: '9999999999', password: 'password')
			player_2 = create(:player)
			game_1 = create(:game, players: [player, player_2], current_player: player.id)
			create(:game, players: [player, player_2], current_player: player.id)
			game_3 = create(:game, players: [player, player_2], current_player: player.id)
			create(:friend, player_id: player.id, friend_id: player_2.id)


			params = {username: 'Lord Rattington', password: 'password'}

			get "/api/v1/login", params: params, headers: {"CONTENT_TYPE" => 'application/json', 'ACCEPT' => 'application/json'}

			response_body = JSON.parse(response.body, symbolize_names: true)

			expect(response.status).to eq(200)
			expect(response_body[:id]).to eq(player.id)
			expect(response_body[:username]).to eq(player.username)
			expect(response_body[:token]).to eq(player.token)
			expect(response_body[:games].count).to eq(3)
			expect(response_body[:games].first[:id]).to eq(game_1.id)
			expect(response_body[:games].first[:players]).to eq([player.username, player_2.username])
			expect(response_body[:games].last[:id]).to eq(game_3.id)
			expect(response_body[:games].last[:players]).to eq([player.username, player_2.username])
			expect(response_body[:friends].count).to eq(1)
			expect(response_body[:friends].first[:id]).to eq(player_2.id)
			expect(response_body[:friends].first[:username]).to eq(player_2.username)
		end

		it('cant retrieve player with only username') do
			create(:player, username: 'Lord Rattington', phone_number: '9999999999')
			params = {username: 'Lord Rattington'}

			get "/api/v1/login", params: params, headers: {"CONTENT_TYPE" => 'application/json', 'ACCEPT' => 'application/json'}

			response_body = JSON.parse(response.body, symbolize_names: true)

			expect(response.status).to eq(400)
			expect(response_body[:message]).to eq('User could not be found')
		end

		it('cant retrieve player with only password') do
			create(:player, username: 'Lord Rattington', phone_number: '9999999999')
			params = {password: 'password'}

			get "/api/v1/login", params: params, headers: {"CONTENT_TYPE" => 'application/json', 'ACCEPT' => 'application/json'}

			response_body = JSON.parse(response.body, symbolize_names: true)

			expect(response.status).to eq(400)
			expect(response_body[:message]).to eq('User could not be found')
		end
	end

	context('GET player by id') do
		it('can retrieve player, see their games and friends') do
			player = create(:player, username: 'Lord Rattington', phone_number: '9999999999', password: 'password')
			player_2 = create(:player)
			game_1 = create(:game, players: [player, player_2], current_player: player.id)
			create(:game, players: [player, player_2], current_player: player.id)
			game_3 = create(:game, players: [player, player_2], current_player: player.id)
			create(:friend, player_id: player.id, friend_id: player_2.id)

			get "/api/v1/players/#{player.id}", headers: {"CONTENT_TYPE" => 'application/json', 'ACCEPT' => 'application/json'}

			response_body = JSON.parse(response.body, symbolize_names: true)

			expect(response.status).to eq(200)
			expect(response_body[:id]).to eq(player.id)
			expect(response_body[:username]).to eq(player.username)
			expect(response_body[:token]).to eq(player.token)
			expect(response_body[:games].count).to eq(3)
			expect(response_body[:games].first[:id]).to eq(game_1.id)
			expect(response_body[:games].first[:players]).to eq([player.username, player_2.username])
			expect(response_body[:games].last[:id]).to eq(game_3.id)
			expect(response_body[:games].last[:players]).to eq([player.username, player_2.username])
			expect(response_body[:friends].count).to eq(1)
			expect(response_body[:friends].first[:id]).to eq(player_2.id)
			expect(response_body[:friends].first[:username]).to eq(player_2.username)
		end
	end

	context('SEARCH players by username/phone number') do
		it('returns all players with partial username match') do
			player_1 = create(:player, username: 'maxscores')
			player_2 = create(:player, username: 'maxhouse')
			player_3 = create(:player, username: 'maximum')
			player_4 = create(:player, username: 'tmadsen')
			player_5 = create(:player, username: 'stackmaxhouse')

			params = {user_query: 'max'}

			get "/api/v1/players", params: params, headers: {"CONTENT_TYPE" => 'application/json', 'ACCEPT' => 'application/json'}

			response_body = JSON.parse(response.body, symbolize_names: true)

			expect(response.status).to eq(200)
			expect(response_body[:players].count).to eq(4)
			expect(response_body[:players][0][:id]).to eq(player_1.id)
			expect(response_body[:players][0][:username]).to eq(player_1.username)
			expect(response_body[:players][0][:token]).to be_nil
			expect(response_body[:players][1][:id]).to eq(player_2.id)
			expect(response_body[:players][1][:username]).to eq(player_2.username)
			expect(response_body[:players][1][:token]).to be_nil
			expect(response_body[:players][2][:id]).to eq(player_3.id)
			expect(response_body[:players][2][:username]).to eq(player_3.username)
			expect(response_body[:players][2][:token]).to be_nil
			expect(response_body[:players][3][:id]).to eq(player_5.id)
			expect(response_body[:players][3][:username]).to eq(player_5.username)
			expect(response_body[:players][3][:token]).to be_nil
		end
	end
end
