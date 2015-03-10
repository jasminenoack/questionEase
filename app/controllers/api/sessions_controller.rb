class Api::SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_user(params[:username], params[:password])
    if @user
      log_in(@user)
      render "api/users/show"
    else
      render json: @user.errors.full_messages
    end
  end

  def destroy
    log_out
    render json: nil
  end
end
