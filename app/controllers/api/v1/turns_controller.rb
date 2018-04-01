class Api::V1::TurnsController < ApplicationController
  def create
    turn = Turn.record_turn(params)
    if turn.save!
      render status: 200
    end
  end
end
