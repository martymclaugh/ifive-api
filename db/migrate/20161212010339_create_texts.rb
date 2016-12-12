class CreateTexts < ActiveRecord::Migration[5.0]
  def change
    create_table :texts do |t|
      t.integer :user_id, null: false
      t.string :phone_number, null: false
      t.timestamps
    end
  end
end
