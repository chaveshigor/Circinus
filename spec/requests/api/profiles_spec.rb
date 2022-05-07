# frozen_string_literal: true

require 'rails_helper'
require './spec/utils/auth_user'

RSpec.describe 'Api::Profiles', type: :request do
  let!(:state) { create(:state) }
  let!(:city) { create(:city, state: state) }

  let!(:user) { create(:user) }
  let!(:user2) { create(:user, first_name: 'light', last_name: 'yagami', password_digest: 'death_note') }
  let!(:user3) { create(:user, first_name: 'misa', last_name: 'misa') }

  let!(:profile_sender) { create(:profile, city: city, user: user) }
  let!(:profile_receiver) { create(:profile, city: city, user: user2) }
  let!(:seen_profile) { create(:profile, city: city, user: user3) }

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

  def update_profile_request(jwt, profile_id, city_id, description)
    put "/api/profiles/#{profile_id}", headers: { Authorization: jwt }, params: {
      profile_edit: {
        description: description,
        city_id: city_id,
      }
    }
  end

  def index_profiles(jwt)
    get '/api/profiles', headers: { Authorization: jwt }
  end

  before(:each) do
    @jwt = auth_user_request(user.email, 'P4ssW02d!')['jwt']
    @born = Date.new(1996, 10, 25)
  end

  describe 'GET #index' do
    context 'When show profiles' do
      it 'show profiles in the same city, except me' do  
        index_profiles(@jwt)
        response_body = JSON.parse(response.body, object_class: OpenStruct)

        expect(response_body.data.map { |p| p['id'].to_i }).to eq([profile_receiver.id, seen_profile.id])
        expect(response_body.data.find { |p| p['id'].to_i == profile_sender.id }).to be(nil)
      end

      it 'show profiles I havent interacted with' do
        Dislike.create(profile_receiver_id: seen_profile.id, profile_sender_id: profile_sender.id)
        index_profiles(@jwt)
        response_body = JSON.parse(response.body, object_class: OpenStruct)

        expect(response_body.data.map { |p| p['id'].to_i }).to eq([profile_receiver.id])
        expect(response_body.data.find { |p| p['id'].to_i == profile_sender.id }).to be(nil)
      end
    end
  end

  describe 'PUT #update' do
    context "When user update profile" do
      it 'update a profile description' do
        prof1 = Profile.create({ born: @born, description: 'I like cats with my S2', city_id: city.id, user_id: user.id })
        description = 'I will be the god of the new world'

        update_profile_request(@jwt, prof1.id, city.id, description)
        response_body = JSON.parse(response.body, object_class: OpenStruct)

        expect(response.status).to eq(200)
      end
    end
  end
end
