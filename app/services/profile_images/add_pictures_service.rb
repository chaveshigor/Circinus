# frozen_string_literal: true

class ProfileImages::AddPicturesService < ApplicationService
  def initialize(pictures, profile)
    @pictures = pictures
    @profile = profile
  end

  def run
    add_picture
  end

  private

  attr_reader :pictures, :profile

  def add_picture
    new_pictures = []

    pictures.each do |picture|
      picture_file = picture[1]['file']
      picture_position = picture[1]['position']

      extention = File.extname(picture_file.tempfile.path)
      raise StandardError, 'Extension not allowed' unless Picture.allowed_extentions.include?(extention)

      s3_key = S3::UploadService.new(picture_file.tempfile.path).run
      new_pictures << Picture.create({storage_service_key: s3_key, position: picture_position, profile_id: profile.id})
    end

    new_pictures
  end
end
