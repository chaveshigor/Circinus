# frozen_string_literal: true

require 'carrierwave/orm/activerecord'

class Picture < ApplicationRecord
  mount_uploader :picture_s3, PictureUploader
  belongs_to :profile
end
