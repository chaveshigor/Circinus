# frozen_string_literal: true

module ProfileImages
  class AddPicturesService < ApplicationService
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
      uploader = S3::UploadService.new(ENV['S3_PROFILE_PICTURES_FOLDER_NAME'])

      pictures.each do |picture|
        picture_file = picture[1]['file']
        picture_position = picture[1]['position']
        extention = File.extname(picture_file.tempfile.path)
        unless Picture.allowed_extentions.include?(extention)
          raise StandardError, 'Extension not allowed'
        end

        s3_key = uploader.run(picture_file.tempfile.path)
        new_pictures << Picture.create(
          {
            storage_service_key: s3_key,
            position:            picture_position,
            profile_id:          profile.id
          }
        )
      end

      new_pictures
    end
  end
end
