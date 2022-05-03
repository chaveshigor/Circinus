# frozen_string_literal: true

require 'rails_helper'

RSpec.describe S3::UploadService do
  describe '#run' do
    it 'upload file to s3' do
      new_file = 'spec/fixtures/images/best-image.jpg'
      file_name = new_file.split('/').last

      allow(Aws::S3::Client).to receive_message_chain(:new, :put_object)

      s3_key = S3::UploadService.new(new_file).run
      expect(s3_key).to eq("#{ENV['S3_MAIN_FOLDER_NAME']}/#{file_name}")
    end
  end
end
