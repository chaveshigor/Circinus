# frozen_string_literal: true

require 'rails_helper'

RSpec.describe S3::DeleteService do
  let!(:s3_key) { 'key_example' }
  let!(:url_example) { 'https://s3.example.com' }

  before(:each) do
    @fake_s3 = instance_double(Aws::S3::Client)
    allow(Aws::S3::Client).to receive(:new).and_return(@fake_s3)
    allow(@fake_s3).to receive(:delete_object).and_return(true)
  end

  describe '#run' do
    it 'delete file from s3' do
      expect(Aws::S3::Client).to receive(:new).and_return(@fake_s3)
      expect(@fake_s3).to receive(:delete_object)

      deleted = S3::DeleteService.new.run(s3_key)
      expect(deleted).to be_truthy
    end
  end
end
