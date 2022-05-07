# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Assossiations' do
    it { should have_one(:profile) }
  end

  describe 'Validations' do
    subject do
      User.new({
                 email:           'me@example.com',
                 password_digest: 'P@ssW0rd',
                 first_name:      'eren',
                 last_name:       'yeager'
               })
    end

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }

    it { should validate_presence_of(:password_digest) }
    it { should validate_length_of(:password_digest).is_at_least(8) }

    it { should validate_presence_of(:first_name) }
    it { should validate_length_of(:first_name).is_at_least(2) }

    it { should validate_presence_of(:last_name) }
    it { should validate_length_of(:last_name).is_at_least(2) }
  end

  it 'create a new user' do
    user = User.new({
                      email:           'me@example.com',
                      password_digest: 'P@ssW0rd',
                      first_name:      'eren',
                      last_name:       'yeager'
                    })

    expect(user).to be_valid
    expect(user.full_name).to eq('Eren Yeager')
  end
end
