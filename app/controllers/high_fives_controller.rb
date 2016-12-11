class HighFivesController < ApplicationController
  def create
    GlobalPhone.db_path = Rails.root.join('db/global_phone.json')
    number_object = GlobalPhone.parse(params[:phone_number])
    number = number_object.national_string
    if number.length == 10
      @user = User.find(params[:user_id])
      @high_five = HighFive.new(sender_id: params[:user_id], receiver_phone_number: number, giver_name: "#{@user.first_name} #{@user.last_name}", receiver_name: params[:friend_name])
      if @high_five.save
        @phone_number = PhoneNumber.find_by(phone_number: @high_five.receiver_phone_number)
        if @phone_number && @phone_number.verified
          # send push notification
          render json: @high_five
        else
          pem = File.join(Rails.root, 'certificates', 'ios_push_certificate.pem')
          apn = Houston::Client.development
          apn.certificate = File.read(pem)
          token = '<287b976e6fb3a5030d8c86b9c512eb1af360364dcb85fd885a028e0d89cc06f0>'
          notification = Houston::Notification.new(device: token)
          notification.alert = "Hello, World!"
          apn.push(notification)
          p notification
          puts "Error: #{notification.error}." if notification.error
          p '*' * 100
          p "HELLO"
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
