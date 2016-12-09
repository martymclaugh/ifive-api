class CreateHighFives < ActiveRecord::Migration[5.0]
  def change
    create_table :high_fives do |t|
      t.integer :sender_id
      t.string :receiver_phone_number
      t.string :receiver_name
      t.string :giver_name

      t.timestamps
    end
  end
end
