# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user
  belongs_to :city

  has_many :pictures
  has_many :likes, foreign_key: :profile_sender_id
  has_many :dislikes, foreign_key: :profile_sender_id
  has_many :profile_hobbies
  has_many :hobbies, through: :profile_hobbies

  validates_presence_of :user
  validates_presence_of :city

  validates :description, presence: true, length: { minimum: 16 }

  scope :except_current_profile, -> (current_user) { where.not({ user_id: current_user.id }) }
  scope :from_same_city, -> (current_user) { where({ city_id: current_user.profile.city_id }) }
  scope :unseen_profiles, -> () { where.not(id: Dislike.all.select(:profile_receiver_id)).where.not(id: Like.all.select(:profile_receiver_id)) }

  def calculate_age
    (Date.today - Date.new(born.year, born.month, born.day)).to_i / 365
  end
end
