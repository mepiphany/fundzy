class Campaign < ActiveRecord::Base



  # This integrate FriendlyId within our model
  # we're using the 'name' to generate the 'slug'
  extend FriendlyId
  #1 step to keep history, support old url and if update use new url(step2, go to campaign controller)
  friendly_id :name, use: [:slugged, :history]

  validates :name, presence: true, uniqueness: true
  validates :goal, presence: true, numericality: {greater_than: 10}

  belongs_to :user
  has_many :pledges, dependent: :destroy

  # this enables us to create associated rewards models at the same time we're
  # creating the campaign model.
  # reject_if: :all_blank means that if the user leaves all the fields for the
  #                       reward empty, it will be ignored and not passed to the
  #                       validation
  # allow_destroy: true   means that if you pass in a special attributes _destroy
  #                       with value `true` as part of the `reward` params it
  #                       will delete the reward record all together.
  has_many :rewards, dependent: :destroy
  accepts_nested_attributes_for :rewards, reject_if: :all_blank, allow_destroy: true

  # this is CarrierWave config:
  # :image is the field in the database that will store the image name
  # ImageUploader is the uploader class we created in /app/uploaders/image_uploader.rb
  mount_uploader :image, ImageUploader

  include AASM

  # setting the whiny_transitions: false option makes it so that it won't
 # throw an exception when an invalid transition happen

   aasm whiny_transitions: false do
     state :draft, initial: true
     state :published
     state :unfunded
     state :funded
     state :canceled

     event :publish do
       transitions from: :draft, to: :published
     end

     event :cancel do
       transitions from: [:draft, :published, :funded], to: :canceled
     end

     event :fund do
       transitions from: :published, to: :funded
     end

     event :unfund do
       transitions from: :published, to: :unfunded
     end

   end

   def published
     where(aasm_state: :published)
   end







  # default `to_param` method
  # def to_param
  #   id
  # end

  # def to_param
  #   # for `to_param` to work there must be and id with non-numerical character
  #   # right after. It's good to call a method like `parameterize` which makes it
  #   # url friendly. For instance, `parameterize` replaces spaces with `-`s
  #   "#{id}-#{name}".parameterize
  # end
end
