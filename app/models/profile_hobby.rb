# frozen_string_literal: true

class ProfileHobby < ApplicationRecord
  belongs_to :hobbies
  belongs_to :profiles
end
