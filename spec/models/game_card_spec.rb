require 'rails_helper'
require 'rake'

describe GameCard do
  before(:all) do
		load File.expand_path("../../../lib/tasks/import_cards_built.rake", __FILE__)
		Rake::Task.define_task(:environment)
		Rake::Task['import_cards_built'].invoke
	end

	after(:all) do
		DatabaseCleaner.clean
	end

  context "class methods" do
    it ".new_game with 2 players" do
      game_1 = GameCard.new_game([1,2])

      expect(game_1.count).to eq(17)
      expect(game_1[0].quantity).to eq(46)
      expect(game_1[1].quantity).to eq(10)
      expect(game_1[2].quantity).to eq(40)
      expect(game_1[3].quantity).to eq(30)
      expect(game_1[4].quantity).to eq(8)
      expect(game_1[5].quantity).to eq(8)
      expect(game_1[6].quantity).to eq(8)
      expect(game_1[7].quantity).to eq(10)
      expect(game_1[8].quantity).to eq(10)
      expect(game_1[9].quantity).to eq(10)
      expect(game_1[10].quantity).to eq(10)
      expect(game_1[11].quantity).to eq(10)
      expect(game_1[12].quantity).to eq(10)
      expect(game_1[13].quantity).to eq(10)
      expect(game_1[14].quantity).to eq(10)
      expect(game_1[15].quantity).to eq(10)
      expect(game_1[16].quantity).to eq(10)
    end
    it ".new_game with 3 players" do
      game_1 = GameCard.new_game([1,2,3])

      expect(game_1.count).to eq(17)
      expect(game_1[0].quantity).to eq(39)
      expect(game_1[1].quantity).to eq(20)
      expect(game_1[2].quantity).to eq(40)
      expect(game_1[3].quantity).to eq(30)
      expect(game_1[4].quantity).to eq(12)
      expect(game_1[5].quantity).to eq(12)
      expect(game_1[6].quantity).to eq(12)
      expect(game_1[7].quantity).to eq(10)
      expect(game_1[8].quantity).to eq(10)
      expect(game_1[9].quantity).to eq(10)
      expect(game_1[10].quantity).to eq(10)
      expect(game_1[11].quantity).to eq(10)
      expect(game_1[12].quantity).to eq(10)
      expect(game_1[13].quantity).to eq(10)
      expect(game_1[14].quantity).to eq(10)
      expect(game_1[15].quantity).to eq(10)
      expect(game_1[16].quantity).to eq(10)
    end
    it ".new_game with 4 players" do
      game_1 = GameCard.new_game([1,2,3,4])

      expect(game_1.count).to eq(17)
      expect(game_1[0].quantity).to eq(32)
      expect(game_1[1].quantity).to eq(30)
      expect(game_1[2].quantity).to eq(40)
      expect(game_1[3].quantity).to eq(30)
      expect(game_1[4].quantity).to eq(12)
      expect(game_1[5].quantity).to eq(12)
      expect(game_1[6].quantity).to eq(12)
      expect(game_1[7].quantity).to eq(10)
      expect(game_1[8].quantity).to eq(10)
      expect(game_1[9].quantity).to eq(10)
      expect(game_1[10].quantity).to eq(10)
      expect(game_1[11].quantity).to eq(10)
      expect(game_1[12].quantity).to eq(10)
      expect(game_1[13].quantity).to eq(10)
      expect(game_1[14].quantity).to eq(10)
      expect(game_1[15].quantity).to eq(10)
      expect(game_1[16].quantity).to eq(10)
    end
  end
end
