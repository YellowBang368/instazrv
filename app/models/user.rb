class User < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  acts_as_commontator
  acts_as_voter
  has_many :posts, dependent: :destroy

  # Пользователь идентифицируется по follower_id
  has_many :active_relationships, class_name:  "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships

  scope :all_except, -> (user) { where.not(id: user) }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :1omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :authentication_keys => [:username]


  #validations
  validates :username, presence: true
  validates :username, uniqueness: true
  validates :email, :uniqueness => {:allow_blank => true}

  def follow(user)
    Relationship.create(follower_id: self.id, followed_id: user.id)
  end

  def unfollow(user)
    Relationship.where(follower_id: self.id, followed_id: user.id).first.destroy
  end

  def follows?(user)
    Relationship.where(follower_id: self.id, followed_id: user.id).exists?
  end

  def get_posts
    posts.order(:created_at)
  end

  def email_required?
    false
  end

  def followers_count
    followers.count
  end

  def posts_count
    posts.count
  end
end
