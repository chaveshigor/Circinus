# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user
  belongs_to :city
  has_many :profile_hobbies
  has_many :hobbies, through: :profile_hobbies
  validates :description, presence: true, length: { minimum: 16 }

  def calculate_age
    (Date.today - Date.new(born.year, born.month, born.day)).to_i / 365
  end

  def send_profile
    profile_hash = attributes
    profile_hash['age'] = calculate_age
    profile_hash['full_name'] = user.full_name
    profile_hash
  end
end
