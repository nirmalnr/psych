class Scorecard < ApplicationRecord
    belongs_to :room
    belongs_to :user
    enum status: [:inactive, :playing, :answered, :ready] 
end
