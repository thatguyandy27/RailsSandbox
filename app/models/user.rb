class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_many :microposts, :dependent => :destroy
  has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
  has_many :followed_users, :through => :relationships, :source => :followed 
  has_many :reverse_relationships, :class_name => "Relationship", :foreign_key => "followed_id", :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower

  before_save { self.email.downcase!}
  before_create :create_remember_token

  validates(:name, presence: true, length:  { maximum: 50})
  validates(:email, presence: true, format: {with: VALID_EMAIL_REGEX}, 
                  uniqueness: { case_sensitive: false})    

  has_secure_password
  validates(:password, length: {minimum: 6})
  validates(:password_confirmation, presence: true)

  def User.new_remember_token
    return SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    return Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    return Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by(:followed_id => other_user.id)
  end

  def follow!(other_user)
    relationships.create!(:followed_id => other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(:followed_id => other_user.id).destroy
  end
  
  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token())
    end
end
