class PhoneNumbersController < ApplicationController
  skip_before_action :authenticate_user_from_token!

  def create
    @phone = PhoneNumber.find_by(phone_number: params[:phone_number])
    unless @phone
      @phone = PhoneNumber.create(phone_number: params[:phone_number], user_id: params[:user_id], verified: false, pin: '')
    end
    @phone.create_pin
    @phone.send_pin
  end

  def update
    @phone = PhoneNumber.find_by(phone_number: params[:phone_number])
    if params[:code] == @phone.pin
      @phone.verification
      render json: @phone
    else
      render json: { error: t('phone_verification_error') }, status: :unprocessable_entity
    end
  end
end
