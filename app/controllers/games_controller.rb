class GamesController < ApplicationController

  def create
    @game = Game.create(game_params)
    render json: @game
  end

  def index
    if params[:time]
      @games = Game.all.sort_by{ |game| game.time}
      @games = @games.reverse
    elsif params[:score]
      @games = Game.all.sort_by{ |game| game.score}
      @games = @games.reverse
    else
      @games = Game.all
    end
    render json: @games
  end

  private

  def game_params
    params.require(:game).permit(:user_id, :score, :time)
  end

end
