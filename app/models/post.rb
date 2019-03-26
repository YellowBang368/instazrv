class Post < ApplicationRecord
  belongs_to :user
  acts_as_commontable dependent: :destroy
  acts_as_votable

  mount_uploader :images, SingleImageUploader

  validates :images, presence: true
end
