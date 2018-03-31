class Api::V1::GamesController < ApplicationController
  def create
    new_game = Game.new_game(params["competitors"])
    if new_game.save!
      render json: new_game
    end
  end
end
