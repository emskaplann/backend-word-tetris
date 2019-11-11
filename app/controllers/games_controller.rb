class GamesController < ApplicationController

  def create
    @game = Game.create(game_params)
    render json: @game
  end

  def index
    @games = Game.all
    render json: @games
  end

  private

  def game_params
    params.require(:game).permit(:user_id, :score, :time)
  end

end
