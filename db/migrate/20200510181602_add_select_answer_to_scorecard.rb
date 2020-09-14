class AddSelectAnswerToScorecard < ActiveRecord::Migration[6.0]
  def change
    add_column :scorecards, :selected_answer, :string
    add_column :scorecards, :active, :boolean, :default => true
  end
end
