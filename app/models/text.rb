class Text < ApplicationRecord
  belongs_to :user
  require 'date'
  def last_text(date)
    time = (Time.now - date.to_time)/1.day
  end
end
