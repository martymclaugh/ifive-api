class PhoneNumbersController < ApplicationController
  def create
    p params
    @phone = PhoneNumber.find_by(phone_number: params[:phone_number])
    unless @phone
      @phone = PhoneNumber.create(phone_number: params[:phone_number], user_id: params[:user_id], verified: false, pin: '')
    end
    @phone.create_pin
    p 'pin created'
    @phone.send_pin
    p 'pin sent?'
  end
end
