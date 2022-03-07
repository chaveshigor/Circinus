# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Profile, type: :model do
  let!(:state) { create(:state) }
  let!(:city) { create(:city, state: state) }
  let!(:user) { create(:user) }

  before(:each) do
    @born = Date.new(1996, 10, 25)
    @fake_profile = {
      description: 'Rasengan is the best jutsu',
      born: @born,
      city_id: city.id,
      user_id: user.id
    }
  end

  it 'create a new profile' do
    prof = Profile.new(@fake_profile)
    expect(prof).to be_valid
    expect(prof.send_profile['full_name']).to eq(user.full_name)
    expect(prof.calculate_age).to be((Date.today - @born).to_i / 365)
  end

  it 'try to create a profile with short description' do
    @fake_profile[:description] = 'Hulk smash'
    prof = Profile.new(@fake_profile)
    expect(prof).to be_invalid
  end

  it 'try to create a profile without description' do
    @fake_profile[:description] = ''
    prof = Profile.new(@fake_profile)
    expect(prof).to be_invalid
  end
end
