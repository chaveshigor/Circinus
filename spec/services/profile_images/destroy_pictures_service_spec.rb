# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProfileImages::DestroyPicturesService do
  let!(:profile) { create(:profile, :with_location, :with_user) }
  let!(:picture) { create(:picture, profile: profile) }

  before(:each) do
    @fake_s3 = instance_double(Aws::S3::Client)
    allow(Aws::S3::Client).to receive(:new).and_return(@fake_s3)
    allow(@fake_s3).to receive(:delete_object).and_return(true)
  end

  describe '#run' do
    it 'destroy pictures' do
      expect(Aws::S3::Client).to receive(:new).and_return(@fake_s3)
      expect(@fake_s3).to receive(:delete_object).and_return(true)

      pictures = [['0', { picture_id: picture.id }.transform_keys!(&:to_s)]]
      expect { ProfileImages::DestroyPicturesService.new(pictures).run }.to change {
                                                                              Picture.count
                                                                            }.by(-1)
    end
  end
end
