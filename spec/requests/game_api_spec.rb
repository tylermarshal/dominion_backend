require 'rails_helper'

describe("Game API") do
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
      game_cards = new_game[:game_cards]
      new_game_id = new_game[:game_id]
      decks = new_game[:decks]

      expect(competitors).to eq(new_game_from_db.competitors.pluck(:id))
      expect(game_cards).to be_a(Hash)
      expect(game_cards.count).to eq(17)
      expect(new_game_id).to eq(new_game_from_db.id)
      expect(decks.count).to eq(2)
      expect(decks.first[:competitor_id]).to be_a(Integer)
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

  context("Post Turn") do
    it("creates a new turn with 2 players") do
      player_1 = create(:player)
      player_2 = create(:player)
      Game.new_game([player_1.id, player_2.id]).save!
      game = Game.all.last

      deck_1 = game.decks[0]
      deck_1.draw = ['copper', 'copper', 'copper', 'copper', 'copper', 'copper', 'copper', 'estate', 'estate', 'estate']
      deck_1.discard = []
      deck_2 = game.decks[1]
      deck_1.draw = ['copper', 'copper', 'copper', 'copper', 'copper', 'copper', 'copper', 'estate', 'estate', 'estate']
      deck_1.discard = []

      deck_1_new_draw = ['copper', 'copper', 'estate', 'copper', 'copper']
      deck_1_new_discard = ['copper', 'copper', 'copper', 'estate', 'estate', 'silver']

      cards_played = ['copper', 'copper', 'copper']
      cards_bought = ['silver']

      params = {
        decks: [
          {
            deck_id: deck_1.id,
            draw: deck_1_new_draw,
            discard: deck_1_new_discard
            },
          {
            deck_id: deck_2.id,
            draw: deck_2.draw,
            discard: deck_2.discard
            }
        ],
        turn: {
          competitor_id: deck_1.competitor.id,
          coins: 3,
          cards_played: cards_played,
          cards_bought: cards_bought
          }
        }

      post "/api/v1/games/#{game.id}/turns", params: params.to_json, headers: {"CONTENT_TYPE" => 'application/json', 'ACCEPT' => 'application/json'}

      expect(response).to be_success

      game = Game.find(game.id)
      deck_1 = game.decks.find(deck_1.id)
      deck_2 = game.decks.find(deck_2.id)
      new_turn = game.turns.first

      expect(game.turns.count).to eq(1)
      expect(deck_1.draw).to eq(deck_1_new_draw)
      expect(deck_1.discard).to eq(deck_1_new_discard)
      expect(new_turn.competitor).to eq(deck_1.competitor)
      expect(new_turn.coins).to eq(3)
      expect(new_turn.cards_played).to eq(cards_played)
      expect(new_turn.cards_bought).to eq(cards_bought)
    end
  end
end
