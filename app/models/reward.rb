class Reward < ActiveRecord::Base
  belongs_to :campaign

  validates :title, presence: true
  validates :amount, presence: true, numericality: {greater_than: 0}
end
