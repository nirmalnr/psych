class CreateScorecards < ActiveRecord::Migration[6.0]
  def change
    create_table :scorecards do |t|
      t.integer :rounds, :default => 0
      t.integer :score, :default => 0
      t.string :user_answer

      t.timestamps
    end
  end
end
