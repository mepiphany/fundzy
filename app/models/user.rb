class User < ActiveRecord::Base

  has_secure_password
  has_many :campaigns, dependent: :nullify
  has_many :pledges, dependent: :destroy

  validates :first_name, presence: true

  validates :email, presence: true,
                    uniqueness: true

  geocoded_by :address
  after_validation :geocode

  def full_name
    "#{first_name} #{last_name}".strip.titleize
  end

end
