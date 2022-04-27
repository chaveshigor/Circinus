# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Profile, type: :model do
  let!(:state) { create(:state) }
  let!(:city) { create(:city, state: state) }
  let!(:user) { create(:user) }

  describe 'Assossiations' do
    it { should belong_to(:user) }
    it { should belong_to(:city) }
    it { should have_many(:pictures) }
    it { should have_many(:profile_hobbies) }
  end

  describe "Validations" do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:city) }
    it { should validate_length_of(:description) }
  end

  it 'create a new profile' do
    born_date = Date.new(1996, 10, 25)
    prof = Profile.new({
      description: 'Rasengan is the best jutsu',
      born: born_date,
      city_id: city.id,
      user_id: user.id
    })

    expect(prof).to be_valid
    expect(prof.calculate_age).to be((Date.today - born_date).to_i / 365)
  end
end
