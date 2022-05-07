# frozen_string_literal: true

module ProfileImages
  class MovePicturesService < ApplicationService
    def initialize(pictures)
      @pictures = pictures
    end

    def run
      move_pictures
    end

    private

    attr_reader :pictures

    def move_pictures
      pictures.each do |picture|
        picture_id = picture[1]['picture_id']
        picture_position = picture[1]['position']

        Picture.update(picture_id, position: picture_position)
      end
    end
  end
end
