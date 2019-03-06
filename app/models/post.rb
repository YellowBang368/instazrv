class Post < ApplicationRecord
  belongs_to :user

  mount_uploader :images, SingleImageUploader

  validates :images, presence: true
end
