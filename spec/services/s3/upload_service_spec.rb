# frozen_string_literal: true

require 'rails_helper'

RSpec.describe S3::UploadService do
  let!(:new_file) { 'spec/fixtures/images/best-image.jpg' }
  let!(:new_file_name) { new_file.split('/').last }

  before(:each) do
    @fake_s3 = instance_double(Aws::S3::Client)
    allow(Aws::S3::Client).to receive(:new).and_return(@fake_s3)
    allow(@fake_s3).to receive(:put_object)
  end

  describe '#run' do
    it 'upload file to s3' do
      s3_key = S3::UploadService.new(ENV['S3_MAIN_FOLDER_NAME']).run(new_file)
      expect(s3_key).to eq("#{ENV['S3_MAIN_FOLDER_NAME']}/#{new_file_name}")
    end
  end
end
