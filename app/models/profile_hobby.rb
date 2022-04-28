# frozen_string_literal: true

class ProfileHobby < ApplicationRecord
  belongs_to :hobby
  belongs_to :profile
end
