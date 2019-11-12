class UsersController < ApplicationController

  def create
    @user = User.create(username: params[:username])
    render json: @user
  end

  def index
    @users = User.all
    render json: @users
  end

end
