class HighFivesController < ApplicationController
  def create
    GlobalPhone.db_path = Rails.root.join('db/global_phone.json')
    number_object = GlobalPhone.parse(params[:phone_number])
    number = number_object.national_string
    if number.length == 10
      @user = User.find(params[:user_id])
      @high_five = HighFive.new(sender_id: params[:user_id], receiver_phone_number: '4156761348')
      if @high_five.save
        @phone_number = PhoneNumber.find_by(phone_number: @high_five.receiver_phone_number)
        if @phone_number && @phone_number.verified
          # send push notification
          render json: @high_five
        else
          # send text
          render json: @high_five
        end
      else
        render json: {error: "Something quite unexplicable happened"}
      end
    else
      render json: {error: "This phone number is not in a valid format. Please check your Address Book and try again."}
    end
  end
end
