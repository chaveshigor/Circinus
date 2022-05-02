# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProfileImages::AddPicturesService do
  let!(:profile) { create(:profile, :with_location, :with_user) }

  describe '#run' do
    it 'upload picture to s3' do
      new_file = 'spec/fixtures/images/best-image.jpg'
      allow(S3::UploadService).to receive_message_chain(:new, :run).and_return(new_file)

      file_instance = double('file_instance')
      allow(file_instance).to receive_message_chain(:tempfile, :path).and_return(new_file)

      pictures = [['0', {file: file_instance, position: '0'}.transform_keys!(&:to_s)]]
      pictures = ProfileImages::AddPicturesService.new(pictures, profile).run

      expect(pictures.present?).to be_truthy
      expect(pictures.map(&:storage_service_key)).to eq([new_file])
    end

    it 'not upload a file with invalid format' do
      new_file = 'spec/fixtures/invalid_images/test.txt'
      allow(S3::UploadService).to receive_message_chain(:new, :run).and_return(new_file)

      file_instance = double('file_instance')
      allow(file_instance).to receive_message_chain(:tempfile, :path).and_return(new_file)

      pictures = [['0', {file: file_instance, position: '0'}.transform_keys!(&:to_s)]]
      expect { ProfileImages::AddPicturesService.new(pictures, profile).run }.to raise_error('Extension not allowed')
    end
  end
end
