# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProfileImages::MovePicturesService do
  let!(:profile) { create(:profile, :with_location, :with_user) }
  let!(:picture) { create(:picture, profile: profile) }

  describe '#run' do
    it 'move pictures' do
      new_position = picture.position + 1
      pictures = [['0', {picture_id: picture.id, position: new_position}.transform_keys!(&:to_s)]]
      ProfileImages::MovePicturesService.new(pictures).run

      expect(picture.reload.position).to eq(new_position)
    end
  end
end
