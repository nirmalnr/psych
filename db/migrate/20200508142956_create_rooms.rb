class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :question 
      t.string :answer
      t.integer :status, :default => 0

      t.timestamps
    end
  end
end
