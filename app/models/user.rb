class User < ApplicationRecord
  mount_uploader :avatar, SingleImageUploader
  acts_as_commontator
  acts_as_voter
  has_many :posts, dependent: :destroy

  # Пользователь идентифицируется по follower_id
  has_many :active_relationships, class_name:  "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :1omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :authentication_keys => [:username]


  #validations
  validates :username, presence: true
  validates :email, :uniqueness => {:allow_blank => true}
  def email_required?
    false
  end

end
