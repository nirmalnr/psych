class AddReferencesTo < ActiveRecord::Migration[6.0]
  def change
    add_reference :scorecards, :user, index: true
    add_reference :scorecards, :room, index: true
  end
end
