# frozen_string_literal: true

class User < ApplicationRecord
  before_create :set_hash_pass, :sanitaze
  has_one :profile
  validates :email, presence: true, format: { with: /\A[a-zA-Z_0-9-]{1,}@[a-zA-Z.]{1,}+\z/, message: 'invalid email' }
  validates :password_digest, presence: true, length: { minimum: 8 }

  private

  def set_hash_pass
    self.password_digest = BCrypt::Password.create(password_digest)
  end

  def sanitaze
    self.email = email.downcase
  end
end
