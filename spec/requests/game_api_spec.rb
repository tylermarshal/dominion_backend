require 'rails_helper'
require 'rake'

describe("Game API") do
	before(:all) do
		load File.expand_path("../../../lib/tasks/import_cards.rake", __FILE__)
		Rake::Task.define_task(:environment)
		Rake::Task['import_cards'].invoke
	end

	after(:all) do
		DatabaseCleaner.clean
	end

  context("Post Game") do
    it("creates a new game with 2 players") do
      player_1 = create(:player)
      player_2 = create(:player)

      params = {competitors: [player_1.id, player_2.id]}

      post "/api/v1/games", params: params.to_json, headers: {"CONTENT_TYPE" => 'application/json', 'ACCEPT' => 'application/json'}

      expect(response).to be_success
      new_game = JSON.parse(response.body, symbolize_names: true)

      new_game_from_db = Game.last

      competitors = new_game[:competitors]
      trash = new_game[:trash]
      status = new_game[:status]
      game_cards = new_game[:game_cards]
      new_game_id = new_game[:game_id]
      decks = new_game[:decks]

      expect(competitors).to eq(new_game_from_db.competitors.pluck(:player_id))
      expect(trash).to be_a(Array)
      expect(trash).to be_empty
      expect(status).to eq('active')
      expect(game_cards).to be_a(Hash)
      expect(game_cards.count).to eq(17)
      expect(new_game_id).to eq(new_game_from_db.id)
      expect(decks.count).to eq(2)
      expect(decks.first[:player_id]).to be_a(Integer)
      expect(decks.first[:id]).to be_a(Integer)
      expect(decks.first[:draw]).to be_a(Array)
      expect(decks.first[:draw].count).to eq(10)
      expect(decks.first[:discard]).to be_a(Array)
      expect(decks.first[:discard].count).to eq(0)
      expect(decks.first[:deck_makeup].keys.count).to eq(2)
      expect(decks.first[:deck_makeup][:copper]).to eq(7)
      expect(decks.first[:deck_makeup][:estate]).to eq(3)
      expect(new_game[:current_player]).to eq(player_1.id)
      expect(new_game[:turn_order].count).to eq(2)
			expect(new_game[:attack_queue].keys.count).to eq(2)
			expect(new_game[:attack_queue][new_game[:current_player].to_s.to_sym]).to be_a Array
    end
  end

  context("Post Turn") do
		it("creates a new turn with 2 players") do
			player_1 = create(:player)
			player_2 = create(:player)
			Game.new_game([player_1.id, player_2.id]).save!
			game = Game.all.last

			deck_1 = game.decks.find_by(competitor_id: game.competitors.find_by(player_id: player_1.id).id)
			deck_1.draw = ['copper', 'copper', 'copper', 'copper', 'copper', 'copper', 'copper', 'estate', 'estate', 'estate']
			deck_1.discard = []
			deck_2 = game.decks.find_by(competitor_id: game.competitors.find_by(player_id: player_2.id).id)
			deck_2.draw = ['copper', 'copper', 'copper', 'copper', 'copper', 'copper', 'copper', 'estate', 'estate', 'estate']
			deck_2.discard = []

			deck_1_new_draw = ['copper', 'copper', 'estate', 'copper', 'copper']
			deck_1_new_discard = ['copper', 'copper', 'copper', 'estate', 'estate', 'silver']

			cards_played = ['copper', 'copper', 'copper', 'militia']
			cards_gained = ['silver']
			cards_trashed = ['copper', 'estate']

			new_supply = game.game_cards.reduce({}) do |supply, game_card|
				supply[game_card.card.name.downcase] = game_card.quantity - 1
				supply
			end

			attacks_played = ['militia']

			params = {
				supply: new_supply,
				trash: ['copper', 'estate'],
				attack_queue: {"#{player_1.id}": [], "#{player_2.id}": attacks_played},
				deck: {
					draw: deck_1_new_draw,
					discard: deck_1_new_discard
				},
				turn: {
					coins: 3,
					cards_played: cards_played,
					cards_gained: cards_gained,
					cards_trashed: cards_trashed
				}
			}

			post "/api/v1/games/#{game.id}/turns", params: params.to_json, headers: {"CONTENT_TYPE" => 'application/json', 'ACCEPT' => 'application/json'}

			expect(response).to be_success
			game = JSON.parse(response.body)
			
			deck_1 = game['decks'].find {|d| d['id'] === deck_1.id}
			deck_2 = game['decks'].find {|d| d['id'] === deck_2.id}
			new_turn = game['turns'].first
			competitor_2 = game['competitors'].find {|c| c === player_2.id}

			expect(game['turns'].count).to eq(1)
			expect(game['trash']).to eq(cards_trashed)
			expect(game['attack_queue'][competitor_2.to_s]).to eq(attacks_played)
			expect(game['game_cards']).to eq(new_supply)
			expect(deck_1['draw']).to eq(deck_1_new_draw)
			expect(deck_1['discard']).to eq(deck_1_new_discard)
			expect(new_turn['player_id']).to eq(player_1.id)
			expect(new_turn['coins']).to eq(3)
			expect(new_turn['cards_played']).to eq(cards_played)
			expect(new_turn['cards_gained']).to eq(cards_gained)
			expect(new_turn['cards_trashed']).to eq(cards_trashed)
			expect(game['current_player']).to eq(player_2.id)
		end

		it("turns game to complete when any three piles are depleted") do
			player_1 = create(:player)
			player_2 = create(:player)
			Game.new_game([player_1.id, player_2.id]).save!
			game = Game.all.last

			deck_1 = game.decks.find_by(competitor_id: game.competitors.find_by(player_id: player_1.id).id)
			deck_1.draw = ['copper', 'copper', 'copper', 'copper', 'copper', 'copper', 'copper', 'estate', 'estate', 'estate']
			deck_1.discard = []
			deck_2 = game.decks.find_by(competitor_id: game.competitors.find_by(player_id: player_2.id).id)
			deck_2.draw = ['copper', 'copper', 'copper', 'copper', 'copper', 'copper', 'copper', 'estate', 'estate', 'estate']
			deck_2.discard = []

			deck_1_new_draw = ['copper', 'copper', 'estate', 'copper', 'copper']
			deck_1_new_discard = ['copper', 'copper', 'copper', 'estate', 'estate', 'silver']

			cards_played = ['copper', 'copper', 'copper', 'militia']
			cards_gained = ['silver']
			cards_trashed = ['copper', 'estate']

			new_supply = game.game_cards.reduce({}) do |supply, game_card|
				supply[game_card.card.name.downcase] = game_card.quantity - 1
				supply
			end

			new_supply['copper'] = 0
			new_supply['duchy'] = 0
			new_supply['silver'] = 0

			attacks_played = ['militia']

			params = {
				supply: new_supply,
				trash: ['copper', 'estate'],
				attack_queue: {"#{player_1.id}": [], "#{player_2.id}": attacks_played},
				deck: {
					draw: deck_1_new_draw,
					discard: deck_1_new_discard
				},
				turn: {
					coins: 3,
					cards_played: cards_played,
					cards_gained: cards_gained,
					cards_trashed: cards_trashed
				}
			}

			post "/api/v1/games/#{game.id}/turns", params: params.to_json, headers: {"CONTENT_TYPE" => 'application/json', 'ACCEPT' => 'application/json'}

			expect(response).to be_success
			game = JSON.parse(response.body)


			expect(game['game_cards']).to eq(new_supply)
			expect(game['status']).to eq('complete')

		end

		it("turns game to complete when the province pile is depleted") do
			player_1 = create(:player)
			player_2 = create(:player)
			Game.new_game([player_1.id, player_2.id]).save!
			game = Game.all.last

			deck_1 = game.decks.find_by(competitor_id: game.competitors.find_by(player_id: player_1.id).id)
			deck_1.draw = ['copper', 'copper', 'copper', 'copper', 'copper', 'copper', 'copper', 'estate', 'estate', 'estate']
			deck_1.discard = []
			deck_2 = game.decks.find_by(competitor_id: game.competitors.find_by(player_id: player_2.id).id)
			deck_2.draw = ['copper', 'copper', 'copper', 'copper', 'copper', 'copper', 'copper', 'estate', 'estate', 'estate']
			deck_2.discard = []

			deck_1_new_draw = ['copper', 'copper', 'estate', 'copper', 'copper']
			deck_1_new_discard = ['copper', 'copper', 'copper', 'estate', 'estate', 'silver']

			cards_played = ['copper', 'copper', 'copper']
			cards_gained = ['silver']
			cards_trashed = ['copper', 'estate']

			new_supply = game.game_cards.reduce({}) do |supply, game_card|
				supply[game_card.card.name.downcase] = game_card.quantity - 1
				supply
			end

			new_supply['province'] = 0

			attacks_played = ['militia']

			params = {
				supply: new_supply,
				trash: ['copper', 'estate'],
				attack_queue: {"#{player_1.id}": [], "#{player_2.id}": attacks_played},
				deck: {
					draw: deck_1_new_draw,
					discard: deck_1_new_discard
				},
				turn: {
					coins: 3,
					cards_played: cards_played,
					cards_gained: cards_gained,
					cards_trashed: cards_trashed
				}
			}

			post "/api/v1/games/#{game.id}/turns", params: params.to_json, headers: {"CONTENT_TYPE" => 'application/json', 'ACCEPT' => 'application/json'}

			expect(response).to be_success
			game = JSON.parse(response.body)

			expect(game['game_cards']).to eq(new_supply)
			expect(game['status']).to eq('complete')

		end

  end

  context("Get Game") do
    it("gets game with id") do

      player_1 = create(:player)
      player_2 = create(:player)

      params = {competitors: [player_1.id, player_2.id]}

      new_game = Game.new_game(params[:competitors])
      new_game.save!

      get "/api/v1/games/#{new_game.id}"

      expect(response).to be_success
      game_state = JSON.parse(response.body, symbolize_names: true)

      competitors = game_state[:competitors]
      trash = game_state[:trash]
      status = game_state[:status]
      game_cards = game_state[:game_cards]
      game_state_id = game_state[:game_id]
      decks = game_state[:decks]
			score = game_state[:score]

      expect(competitors).to eq(new_game.players.pluck(:id))
      expect(trash).to be_a(Array)
      expect(trash).to be_empty
      expect(status).to eq('active')
      expect(game_cards).to be_a(Hash)
      expect(game_cards.count).to eq(17)
      expect(game_state_id).to eq(new_game.id)
			expect(score).to be_a(Hash)
      expect(decks.count).to eq(2)
      expect(decks.first[:player_id]).to be_a(Integer)
      expect(decks.first[:id]).to be_a(Integer)
      expect(decks.first[:draw]).to be_a(Array)
      expect(decks.first[:draw].count).to eq(10)
      expect(decks.first[:discard]).to be_a(Array)
      expect(decks.first[:discard].count).to eq(0)
      expect(decks.first[:deck_makeup].keys.count).to eq(2)
      expect(decks.first[:deck_makeup][:copper]).to eq(7)
      expect(decks.first[:deck_makeup][:estate]).to eq(3)
    end
  end
end
