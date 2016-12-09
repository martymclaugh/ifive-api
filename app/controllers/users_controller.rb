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
    @phone_number = @user.phone_numbers.where(verified: true)[0]
    @high_fives_given = HighFive.where(sender_id: @user.id).order('created_at DESC')
    @high_fives_received = HighFive.where(receiver_phone_number: @phone_number.phone_number).order('created_at DESC')
    render json: [@user, @phone_number, @high_fives_given, @high_fives_received]
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :password, :email)
  end
end
