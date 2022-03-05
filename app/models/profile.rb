# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user
  has_one :city
end
