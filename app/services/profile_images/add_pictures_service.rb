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

      picture = Image::UploadImageService.new(picture_file.tempfile).run

      new_pictures << Picture.create({url: picture.url, position: picture_position, profile_id: profile.id, picture_s3: picture})
    end

    new_pictures
  end
end
