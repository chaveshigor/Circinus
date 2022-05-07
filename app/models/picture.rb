# frozen_string_literal: true

require 'carrierwave/orm/activerecord'

class Picture < ApplicationRecord
  belongs_to :profile

  attr_accessor :url

  ALLOWED_EXTENTIONS = ['.jpg', '.png', '.jpeg'].freeze

  validates :position, presence: true
  validates :storage_service_key, presence: true

  def self.allowed_extentions
    ALLOWED_EXTENTIONS
  end
end
