# frozen_string_literal: true

require 'carrierwave/orm/activerecord'

class Picture < ApplicationRecord
  belongs_to :profile

  attr_accessor :url

  ALLOWED_EXTENTIONS = ['.jpg', '.png', '.jpeg'].freeze

  validates_presence_of :position
  validates_presence_of :storage_service_key

  def self.allowed_extentions
    ALLOWED_EXTENTIONS
  end

end
