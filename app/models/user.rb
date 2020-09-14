class User < ApplicationRecord
  has_many :scorecards
  has_many :rooms, through: :scorecards
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def username
    return email.split('@')[0]
  end
end
