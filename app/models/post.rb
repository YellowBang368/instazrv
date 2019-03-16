class Post < ApplicationRecord
  belongs_to :user
  acts_as_commontable dependent: :destroy

  mount_uploader :images, SingleImageUploader

  validates :images, presence: true
end
