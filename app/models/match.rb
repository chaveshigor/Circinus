# frozen_string_literal: true

class Match < ApplicationRecord
  belongs_to :profile_1, class_name: :Profile
  belongs_to :profile_2, class_name: :Profile
end
