class User < ApplicationRecord
  has_many :posts, dependent: :destroy

  # Create virtual table active_relationships
  # with Relationship class object
  # where follower_id equals id of User
  has_many :active_relationships, class_name:  "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  # where followed_id equsls id of User
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :1omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #validations
  validates :name, presence: true
end
