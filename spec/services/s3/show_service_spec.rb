# frozen_string_literal: true

require 'rails_helper'

RSpec.describe S3::ShowService do
  let!(:s3_key) { 'key_example' }
  let!(:url_example) { 'https://s3.example.com' }

  before(:each) do
    @fake_signer = instance_double(Aws::S3::Presigner)
    allow(Aws::S3::Presigner).to receive(:new).and_return(@fake_signer)
    allow(@fake_signer).to receive(:presigned_request).and_return(url_example)
  end

  describe '#run' do
    it 'show file url from s3' do
      picture_url = S3::ShowService.new.run(s3_key)
      expect(picture_url).to eq(url_example)
    end
  end
end
