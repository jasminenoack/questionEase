class Api::UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.where(id: params[:id]).includes(:questions).first
    render :show
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      render :show
    else
      render json: @user.errors.full_messages, status: 422
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      log_in(@user)
      render :show
    else
      render json: @user.errors.full_messages, status: 422
    end
  end

  private
  def user_params
    params.require(:user).permit(
      :email,
      :first_name,
      :last_name,
      :username,
      :location,
      :biography,
      :password,
      :password_confirmation
    )
  end
end
