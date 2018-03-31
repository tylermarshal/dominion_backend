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

      new_game_id_from_db = Game.last.id

      competitors = new_game[:competitors]
      game_cards = new_game[:game_cards]
      new_game_id = new_game[:game_id]
      decks = new_game[:decks]

      expect(competitors).to eq([player_1.id, player_2.id])
      expect(game_cards).to be_a(Hash)
      expect(game_cards.count).to eq(17)
      expect(new_game_id).to eq(new_game_id_from_db)
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
end
