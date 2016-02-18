class Campaign < ActiveRecord::Base
  belongs_to :user
  has_many :pledges, dependent: :destroy

   validates :name, presence: true, uniqueness: true
   #
   validates :goal, presence: true,  numericality: {greater_than: 10}

end
