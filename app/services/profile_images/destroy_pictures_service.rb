# frozen_string_literal: true

class ProfileImages::DestroyPicturesService < ApplicationService
  def initialize(pictures)
    @pictures = pictures
  end

  def run
    destroy_pictures
  end

  private

  attr_reader :pictures

  def destroy_pictures
    deleter = S3::DeleteService.new

    pictures.each do |picture|
      picture_id = picture[1]['picture_id']
      deleted_picture = Picture.find(picture_id)

      deleter.run(deleted_picture.storage_service_key)
      deleted_picture.destroy
    end
  end
end
