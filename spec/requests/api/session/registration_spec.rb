# frozen_string_literal: true

require 'rails_helper'
require './spec/utils/auth_user'

RSpec.describe 'Api::States', type: :request do
  let!(:state) { create(:state) }
  let!(:city) { create(:city, state: state) }

  let!(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user, city: city) }

  def create_user_request
    post '/api/session/registration', params: {
      new_user:    {
        first_name:      'son',
        last_name:       'goku',
        email:           'son_goku@example.com',
        password_digest: '12345678'
      },
      new_profile: {
        born:        Date.new(1996, 10, 25),
        description: 'I like hot dogs S2',
        city_id:     city.id
      }
    }
  end

  def delete_user_request(jwt = @jwt)
    delete '/api/session/registration', headers: { Authorization: jwt }
  end

  def confirmate_account_request(user_id, confirmation_token)
    put "/api/session/registration/#{user_id}/#{confirmation_token}"
  end

  before(:each) do
    @jwt = auth_user_request(user.email, 'P4ssW02d!')['jwt']
  end

  describe 'POST /create' do
    context 'When user try to create an account' do
      it 'create a new user and a new profile' do
        expect do
          create_user_request
        end.to change(User, :count).by(1).and change(Profile, :count).by(1)
        response_body = JSON.parse(response.body, object_class: OpenStruct)

        expect(response.status).to eq(201)
        expect(response_body.user.present?).to be(true)
        expect(response_body.profile.present?).to be(true)
      end

      it 'not create a user with an existent email' do
        create_user_request

        expect do
          create_user_request
        end.to change(User, :count).by(0).and change(Profile, :count).by(0)
        response_body = JSON.parse(response.body, object_class: OpenStruct)

        expect(response.status).to eq(403)
        expect(response_body.message).to eq('user already exists')
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'When user try to delete his account' do
      it 'delete an user and his profile' do
        expect do
          delete_user_request
        end.to change(User, :count).by(-1).and change(Profile, :count).by(-1)

        expect(response.status).to eq(204)
      end
    end
  end

  describe 'PUT /confirmate_account' do
    context 'When user try to confirm his account' do
      it 'confirm account' do
        confirmate_account_request(user.id, user.confirmation_token)
        response_body = JSON.parse(response.body)

        expect(User.find(user.id).account_confirmed).to be(true)
      end

      it 'not confirm account - wrong token' do
        confirmate_account_request(user.id, 'kamehameha')
        response_body = JSON.parse(response.body)

        expect(response.status).to eq(401)
        expect(response_body['message']).to eq('wrong token')
        expect(User.find(user.id).account_confirmed).to be(false)
      end

      it 'not confirm account - user dont exists' do
        confirmate_account_request(9999, user.confirmation_token)
        response_body = JSON.parse(response.body)

        expect(response.status).to eq(404)
        expect(response_body['message']).to eq('user not found')
        expect(User.find(user.id).account_confirmed).to be(false)
      end
    end
  end
end
