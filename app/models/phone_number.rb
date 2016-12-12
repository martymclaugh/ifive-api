class PhoneNumber < ApplicationRecord
  belongs_to :user

  def create_pin
    self.pin = rand(0000..9999).to_s.rjust(4, "0")
    save
  end

  def verification
    self.verified = true
    save
  end

  def send_pin
    twilio_cli = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

    twilio_cli.messages.create(
      to: self.phone_number,
      from: ENV['TWILIO_PHONE_NUMBER'],
      body: "iFive: your PIN is #{pin}"
    )
  end

  def send_invite(user)
    twilio_cli = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

    twilio_cli.messages.create(
      to: self.phone_number,
      from: ENV['TWILIO_PHONE_NUMBER'],
      body: "#{user} sent you a High Five! \u{270B} Download the iFive app to send one back: https://itunes.apple.com/us/app/ifives/id1185367518?ls=1&mt=8"
    )
  end

  def verify(entered_pin)
    update(verified: true) if self.pin == entered_pin
  end
end
