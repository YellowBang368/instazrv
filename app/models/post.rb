class Post < ApplicationRecord
  belongs_to :user
  acts_as_commontable dependent: :destroy
  acts_as_votable
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :crop_image

  mount_uploader :images, SingleImageUploader

  validates :images, presence: true
  validate :check_dimensions, :on => :create

  def check_dimensions
    if !images_cache.nil? && (images.width < 600 || images.height < 600)
      errors.add :image, "Dimension is too small."
    end
  end

  def crop_image
    images.recreate_versions! if crop_x.present?
  end
end
