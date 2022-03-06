# frozen_string_literal: true

# User model
class User < ApplicationRecord
  before_create :set_hash_pass, :sanitaze, :create_confirmation_account_token
  has_one :profile
  validates :email,
            presence: true,
            format: { with: /\A[a-zA-Z_0-9-]{1,}@[a-zA-Z.]{1,}\z/, message: 'invalid email' },
            uniqueness: true

  validates :password_digest, presence: true, length: { minimum: 8 }
  validates :first_name, presence: true, length: { minimum: 2 }
  validates :last_name, presence: true, length: { minimum: 2 }

  def full_name
    "#{first_name.titleize} #{last_name.titleize}"
  end

  private

  def set_hash_pass
    self.password_digest = BCrypt::Password.create(password_digest)
  end

  def sanitaze
    self.email = email.downcase
    self.first_name = first_name.downcase
    self.last_name = last_name.downcase
  end

  def create_confirmation_account_token
    self.confirmation_token = SecureRandom.hex(15)
  end
end
