# frozen_string_literal: true

class Hobby < ApplicationRecord
  belongs_to :hobby_category
  has_many :profile_hobbies
  has_many :profiles, through: :profile_hobbies
end
