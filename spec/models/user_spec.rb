# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @fake_user = {
      email: 'me@example.com',
      password_digest: 'P@ssW0rd',
      first_name: 'eren',
      last_name: 'yeager'
    }
  end

  it 'is a valid user' do
    new_user = User.new(@fake_user)
    expect(new_user).to be_valid
    expect(new_user.full_name).to eq("#{@fake_user[:first_name].titleize} #{@fake_user[:last_name].titleize}")
  end

  it 'is an user with invalid email' do
    @fake_user[:email] = 'me!@example.com'
    expect(User.new(@fake_user)).to be_invalid
  end

  it 'is an user with invalid first name' do
    @fake_user[:first_name] = 'L'
    expect(User.new(@fake_user)).to be_invalid
  end

  it 'is an user with invalid last name' do
    @fake_user[:last_name] = 'N'
    expect(User.new(@fake_user)).to be_invalid
  end

  it 'is an user with invalid password' do
    @fake_user[:password_digest] = 'me'
    expect(User.new(@fake_user)).to be_invalid
  end

  it 'is an user with invalid email and password' do
    @fake_user[:email] = 'ruyk!!!@example.com'
    @fake_user[:password_digest] = 'apple'
    expect(User.new(@fake_user)).to be_invalid
  end

  it 'is a invalid user without email and password' do
    @fake_user[:email] = ''
    @fake_user[:password_digest] = ''
    expect(User.new(@fake_user)).to be_invalid
  end
end
