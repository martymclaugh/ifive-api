class HighFive < ApplicationRecord
  has_one :user, :class_name => "User", foreign_key: :sender_id
end
