class HighFivesController < ApplicationController
  def create
    GlobalPhone.db_path = Rails.root.join('db/global_phone.json')
    number_object = GlobalPhone.parse(params[:phone_number])
    @number = number_object.national_string
    if @number.length == 10
      @user = User.find(params[:user_id])
      @high_five = HighFive.new(sender_id: params[:user_id], receiver_phone_number: @number, giver_name: "#{@user.first_name} #{@user.last_name}", receiver_name: params[:friend_name])
      if @high_five.save
        @phone_number = PhoneNumber.find_by(phone_number: @high_five.receiver_phone_number)
        # uncomment for itunes release
        if @phone_number && @phone_number.verified
          # send push notification
          pem = File.join(Rails.root, 'certificates', 'cert_prod.pem')
          apn = Houston::Client.production
          apn.certificate = File.read(pem)
          token = "<#{@phone_number.user.device_token}>"
          notification = Houston::Notification.new(device: token)
          notification.alert = "#{@high_five.giver_name} sent you a Five! \u{270B}"
          apn.push(notification)
          puts "Error: #{notification.error}." if notification.error
          render json: @high_five
        else
          # send text
          @text = Text.find_by(user_id: @user.id, phone_number: @number)
          if @text
            if @text.last_text(@text.created_at) > 1
              @text.update(created_at: DateTime.now)
              @user.phone_numbers[0].send_invite(@high_five.giver_name)
            end
          else
            @text = Text.create(user_id: @user.id, phone_number: @number)
            @user.phone_numbers[0].send_invite(@high_five.giver_name)
          end
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
