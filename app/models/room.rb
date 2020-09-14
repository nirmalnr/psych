class Room < ApplicationRecord
    has_many :scorecards
    has_many :users, through: :scorecards
    enum status: [:waiting_for_players, :waiting_for_bs, :waiting_for_answer, :show_score]

end
