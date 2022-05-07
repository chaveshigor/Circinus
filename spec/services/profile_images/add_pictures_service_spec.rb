# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProfileImages::AddPicturesService do
  let!(:profile) { create(:profile, :with_location, :with_user) }
  let!(:profile_pics_folder) { ENV['S3_PROFILE_PICTURES_FOLDER_NAME'] }

  let!(:new_file) { 'spec/fixtures/images/best-image.jpg' }
  let!(:new_file_name) { new_file.split('/').last }

  let!(:invalid_file) { 'spec/fixtures/invalid_images/test.txt' }
  let!(:invalid_file_name) { new_file.split('/').last }

  before(:each) do
    @fake_s3 = instance_double(Aws::S3::Client)
    allow(Aws::S3::Client).to receive(:new).and_return(@fake_s3)
    allow(@fake_s3).to receive(:put_object)
  end

  def mock_file_instance(file_path)
    file_instance = double('file_instance')
    temp_file_instance = double('temp_file_instance')

    allow(file_instance).to receive(:tempfile).and_return(temp_file_instance)
    allow(temp_file_instance).to receive(:path).and_return(file_path)

    file_instance
  end

  describe '#run' do
    it 'upload picture to s3' do
      file_instance = mock_file_instance(new_file)

      pictures = [['0', { file: file_instance, position: '0' }.transform_keys!(&:to_s)]]
      pictures = ProfileImages::AddPicturesService.new(pictures, profile).run

      expect(pictures.map(&:storage_service_key)).to eq(["#{profile_pics_folder}/#{new_file_name}"])
    end

    it 'not upload a file with invalid format' do
      file_instance = mock_file_instance(invalid_file)

      pictures = [['0', { file: file_instance, position: '0' }.transform_keys!(&:to_s)]]
      expect do
        ProfileImages::AddPicturesService.new(pictures,
                                              profile).run
      end.to raise_error('Extension not allowed')
    end
  end
end
