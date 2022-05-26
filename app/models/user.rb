class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy

  has_many :relationships, foreign_key: :follower_id
  has_many :followers, through: :relationships, source: :followed

  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: :followed_id
  has_many :followeds, through: :reverse_of_relationships, source: :follower

  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true

  def is_followed_by?(user)
    reverse_of_relationships.find_by(follower_id: user.id).present?
  end

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
end
