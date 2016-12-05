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
      body: "your PIN is #{pin}"
    )
  end

  def verify(entered_pin)
    update(verified: true) if self.pin == entered_pin
  end
end
