class RemoveActiveFromScorecard < ActiveRecord::Migration[6.0]
  def change
    remove_column :scorecards, :active, :boolean
    add_column :scorecards, :status, :integer, :default => 1
  end
end
