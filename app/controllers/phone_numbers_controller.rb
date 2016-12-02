class PhoneNumbersController < ApplicationController
  def new
    @phone_number = PhoneNumbers.new
  end
end
