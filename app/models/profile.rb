# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user
  belongs_to :city
  has_many :pictures
  has_many :profile_hobbies
  has_many :hobbies, through: :profile_hobbies

  validates_presence_of :user
  validates_presence_of :city

  validates :description, presence: true, length: { minimum: 16 }

  def calculate_age
    (Date.today - Date.new(born.year, born.month, born.day)).to_i / 365
  end
end
