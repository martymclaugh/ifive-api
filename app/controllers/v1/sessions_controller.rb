module V1
  class SessionsController < ApplicationController
    skip_before_action :authenticate_user_from_token!

    def create
      @phone_number = PhoneNumber.where(phone_number: params[:phone_number])[0]
      @user = User.find(@phone_number.user_id)
      @user_info = [@user, @phone_number]
      return invalid_login_attempt unless @user
      if @user.valid_password?(params[:password])
        sign_in(@user)
        render json: [@user, @phone_number]
      else
        invalid_login_attempt
      end
    end

    private

    def invalid_login_attempt
      warden.custom_failure!
      render json: {error: t('sessions_controller.invalid_login_attempt')}, status: :unprocessable_entity
    end
  end
end
