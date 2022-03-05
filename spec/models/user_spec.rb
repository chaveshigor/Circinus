# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is a valid user' do
    expect(User.new(email: 'me@example.com', password_digest: 'P@ssW0rd')).to be_valid
  end

  it 'is an user with invalid email' do
    expect(User.new(email: 'me!@example.com', password_digest: 'P@ssW0rd')).to be_invalid
  end

  it 'is an user with invalid password' do
    expect(User.new(email: 'me@example.com', password_digest: '5')).to be_invalid
  end

  it 'is an user with invalid email and password' do
    expect(User.new(email: 'me!@example.com', password_digest: '5')).to be_invalid
  end

  it 'is a invalid user without email and password' do
    expect(User.new(email: '', password_digest: '')).to be_invalid
  end
end
