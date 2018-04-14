require 'rails_helper'

describe('Player API') do
	before(:each) do
		DatabaseCleaner.clean
	end

	context('POST player') do
		it('creates a new player') do
			params = {username: 'Lord Rattington', password: 'password', phone_number: '999-999-9999'}

			post "/api/v1/players", params: params.to_json, headers: {"CONTENT_TYPE" => 'application/json', 'ACCEPT' => 'application/json'}

			expect(response).to be_success
			new_player = JSON.parse(response.body, symbolize_names: true)
			last_player = Player.last

			expect(new_player[:id]).to eq(last_player.id)
			expect(new_player[:username]).to eq(last_player.username)
			expect(new_player[:token]).to be_truthy
		end

		it('username is not unique') do
			create(:player, username: 'Lord Rattington')
			params = {username: 'Lord Rattington', password: 'password', phone_number: '9999999999'}

			post "/api/v1/players", params: params.to_json, headers: {"CONTENT_TYPE" => 'application/json', 'ACCEPT' => 'application/json'}

			response_body = JSON.parse(response.body, symbolize_names: true)

			expect(response.status).to eq(400)
			expect(response_body[:message]).to eq('Username and Phone Number must be unique')
		end

		it('phone number is not unique') do
			create(:player, phone_number: '9999999999')
			params = {username: 'Lord Rattington', password: 'password', phone_number: '9999999999'}

			post "/api/v1/players", params: params.to_json, headers: {"CONTENT_TYPE" => 'application/json', 'ACCEPT' => 'application/json'}

			response_body = JSON.parse(response.body, symbolize_names: true)

			expect(response.status).to eq(400)
			expect(response_body[:message]).to eq('Username and Phone Number must be unique')
		end
	end

	context('GET player by credentials') do
		it('can retrieve player with correct credentials') do
			player = create(:player, username: 'Lord Rattington', phone_number: '9999999999', password: 'password')
			params = {username: 'Lord Rattington', password: 'password'}

			get "/api/v1/player", params: params, headers: {"CONTENT_TYPE" => 'application/json', 'ACCEPT' => 'application/json'}

			response_body = JSON.parse(response.body, symbolize_names: true)

			expect(response.status).to eq(200)
			expect(response_body[:id]).to eq(player.id)
			expect(response_body[:username]).to eq(player.username)
			expect(response_body[:token]).to eq(player.token)
		end

		it('cant retrieve player with only username') do
			create(:player, username: 'Lord Rattington', phone_number: '9999999999')
			params = {username: 'Lord Rattington'}

			get "/api/v1/player", params: params, headers: {"CONTENT_TYPE" => 'application/json', 'ACCEPT' => 'application/json'}

			response_body = JSON.parse(response.body, symbolize_names: true)

			expect(response.status).to eq(400)
			expect(response_body[:message]).to eq('User could not be found')
		end

		it('cant retrieve player with only password') do
			create(:player, username: 'Lord Rattington', phone_number: '9999999999')
			params = {password: 'password'}

			get "/api/v1/player", params: params, headers: {"CONTENT_TYPE" => 'application/json', 'ACCEPT' => 'application/json'}

			response_body = JSON.parse(response.body, symbolize_names: true)

			expect(response.status).to eq(400)
			expect(response_body[:message]).to eq('User could not be found')
		end
	end

	context('SEARCH players by username/phone number') do

	end
end
