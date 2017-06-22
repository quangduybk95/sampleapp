class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  attr_accessor :remember_token

  before_save :downcase_email

  has_secure_password

  validates :name, presence: true, length:
    {maximum: Settings.name_maximum_length}
  validates :email, presence: true,
    length: {maximum: Settings.email_maximum_length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.password_minimum_length}, allow_nil: true

  class << self
    def digest string
      if cost = ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
      BCrypt::Password.create string, cost: cost
    end

    def User.new_token
      SecureRandom.urlsafe_base64
    end
  end

  def downcase_email
    self.email = email.downcase
  end

  def forget
    update_attributes remember_digest: nil
  end

  def remember
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticated?
    return false unless remember_digest
    BCrypt::Password.new(remember_digest).is_password? :remember_token
  end
end
