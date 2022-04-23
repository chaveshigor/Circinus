# frozen_string_literal: true

class Image::UploadImageService < ApplicationService
  def initialize(image)
    @image = image
  end

  def run
    uploadImage
  end

  private

  attr_reader :image

  def uploadImage
    uploader = PictureUploader.new
    uploader.store!(image)
    uploader
  end
end
