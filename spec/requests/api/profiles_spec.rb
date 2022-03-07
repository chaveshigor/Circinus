# frozen_string_literal: true

require 'rails_helper'
require './spec/utils/auth_user'

RSpec.describe 'Api::Profiles', type: :request do
  let!(:state) { create(:state) }
  let!(:city) { create(:city, state: state) }
  let!(:user) { create(:user) }
  let!(:user2) { create(:user, first_name: 'light', last_name: 'yagami', password_digest: 'death_note') }

  def create_profile_request(jwt, city_id, born, description = 'I like hot dogs S2')
    post '/api/profiles', params: {
      profile: {
        born: born,
        description: description,
        city_id: city_id
      }
    }, headers: {
      Authorization: jwt
    }
  end

  def index_profiles(jwt)
    get '/api/profiles', headers: { Authorization: jwt }
  end

  before(:each) do
    @jwt = auth_user_request(user.email, 'P4ssW02d!')['jwt']
    @born = Date.new(1996, 10, 25)
  end

  describe 'POST /create' do
    it 'create a new profile' do
      create_profile_request(@jwt, city.id, @born)
      response_body = JSON.parse(response.body)

      expect(response_body['status']).to eq('success')
      expect(response_body['profile'].present?).to be(true)
      expect(response_body['profile']['age']).to eq((Date.today - @born).to_i / 365)
      expect(Profile.find(response_body['profile']['id']).present?).to be(true)
    end

    it 'create a new profile with short description' do
      create_profile_request(@jwt, city.id, @born, 'Which Mario?')
      response_body = JSON.parse(response.body)

      expect(response_body['status']).to eq('failed')
      expect(response_body['profile'].present?).to be(false)
    end

    it 'create a new profile without description' do
      create_profile_request(@jwt, city.id, @born, '')
      response_body = JSON.parse(response.body)

      expect(response_body['status']).to eq('failed')
      expect(response_body['profile'].present?).to be(false)
    end

    it 'try to create a new profile with invalid jwt' do
      create_profile_request('asasasas', city.id, @born)
      response_body = JSON.parse(response.body)

      expect(response_body['status']).to eq('unauthorized')
      expect(response_body['profile'].present?).to be(false)
    end

    it 'try to create a new profile with invalid city' do
      create_profile_request(@jwt, 99_999, @born)
      response_body = JSON.parse(response.body)

      expect(response_body['status']).to eq('failed')
      expect(response_body['message']).to eq('city not found')
    end
  end

  describe 'GET /index' do
    it 'show profiles in the same city' do
      prof1 = Profile.create({ born: @born, description: 'I like cats with my S2', city_id: city.id, user_id: user.id })
      prof2 = Profile.create({ born: @born, description: 'I need to eat some pies', city_id: city.id, user_id: user2.id })
      index_profiles(@jwt)
      response_body = JSON.parse(response.body)

      expect(response_body['profiles'].map { |p| p['id'] }).to eq([prof2.id])
      expect(response_body['profiles'].find { |p| p['id'] == prof1.id }).to be(nil)
    end
  end
end
