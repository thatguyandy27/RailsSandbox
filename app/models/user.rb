class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_many :microposts, :dependent => :destroy

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
    return Micropost.where("user_id = ?", id)
  end
  
  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token())
    end
end
