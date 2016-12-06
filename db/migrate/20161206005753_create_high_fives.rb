class CreateHighFives < ActiveRecord::Migration[5.0]
  def change
    create_table :high_fives do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.string :type

      t.timestamps
    end
  end
end
