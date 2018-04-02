class Api::V1::GamesController < ApplicationController
  def show
    game = Game.find(params[:id])
    if game
      render json: game
    end
  end

  def create
    new_game = Game.new_game(params["competitors"])
    if new_game.save!
      render json: new_game
    end
  end
end
