class Post < ApplicationRecord
  belongs_to :user

  mount_uploader :images, PostImagesUploader

  validates :image, presence: true
end
