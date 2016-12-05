class UsersController < ApplicationController
  skip_before_action :authenticate_user_from_token!, only: [:create]

  def create
    if params[:user][:password] == params[:user][:password_confirmation]
      @user = User.new(user_params)
    else
    render json: { error: t('user_create_error') }, status: :unprocessable_entity
    end
    if @user.save
      render json: @user, serializer: V1::SessionSerializer, root: nil
    else
      render json: { error: t('user_create_error') }, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
    render json: @user
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :password, :email)
  end
end
