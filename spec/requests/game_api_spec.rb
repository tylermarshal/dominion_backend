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

      new_game_id = Game.last.id

      expect(new_game[:competitors]).to eq([player_1.id, player_2.id])
      expect(new_game[:game_cards].count).to eq(17)
      expect(new_game[:game_cards]).to be_a(Hash)
      expect(new_game[:game_id]).to eq(new_game_id)
      expect(new_game[:decks].count).to eq(2)
      expect(new_game[:decks].first[:competitor_id]).to be_a(Integer)
      expect(new_game[:decks].first[:id]).to be_a(Integer)
      expect(new_game[:decks].first[:draw]).to be_a(Array)
      expect(new_game[:decks].first[:draw].count).to eq(10)
      expect(new_game[:decks].first[:discard]).to be_a(Array)
      expect(new_game[:decks].first[:discard].count).to eq(0)
      expect(new_game[:decks].first[:deck_makeup]).to eq({"32" => 7, "36" => 3})
      # copper = 32, estate = 36
    end
  end
end
