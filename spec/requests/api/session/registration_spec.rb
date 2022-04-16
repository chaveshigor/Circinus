# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::States', type: :request do
  let!(:state) { create(:state) }
  let!(:city) { create(:city, state: state) }
  let!(:user) { create(:user) }

  def create_user_request
    post '/api/session/registration', params: {
      new_user: {
        first_name: 'son',
        last_name: 'goku',
        email: 'son_goku@example.com',
        password_digest: '12345678'
      },
      new_profile: { 
        born: Date.new(1996, 10, 25),
        description: 'I like hot dogs S2',
        city_id: city.id,
      }
    }
  end

  def delete_user_request(id)
    delete '/api/session/registration', params: {
      user_to_delete: {
        id: id
      }
    }
  end

  def confirmate_account_request(user_id, confirmation_token)
    put "/api/session/registration/#{user_id}/#{confirmation_token}"
  end

  describe 'POST /create' do
    context 'When user create an account' do
      it 'create a new user and a new profile' do
        expect{ create_user_request }.to change(User, :count).by(1).and change(Profile, :count).by(1)
        response_body = JSON.parse(response.body, object_class: OpenStruct)

        expect(response.status).to eq(201)
        expect(response_body.user.present?).to be(true)
        expect(response_body.profile.present?).to be(true)
      end
   
      it 'not create a user with an existent email' do
        create_user_request

        expect{ create_user_request }.to change(User, :count).by(0).and change(Profile, :count).by(0)
        response_body = JSON.parse(response.body, object_class: OpenStruct)

        expect(response.status).to eq(403)
        expect(response_body.message).to eq('user already exists')
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'delete an user' do
      delete_user_request(user.id)
      response_body = JSON.parse(response.body)

      expect(response_body['status']).to eq('success')
    end

    it 'try to delete an unexistent user' do
      delete_user_request(999_999)
      response_body = JSON.parse(response.body)

      expect(response_body['status']).to eq('failed')
      expect(response_body['message']).to eq('user dont exists')
    end
  end

  describe 'PUT /confirmate_account' do
    it 'confirm account' do
      confirmate_account_request(user.id, user.confirmation_token)
      response_body = JSON.parse(response.body)

      expect(response_body['status']).to eq('success')
      expect(response_body['message']).to eq('account confirmed')
      expect(User.find(user.id).account_confirmed).to be(true)
    end

    it 'not confirm account - wrong token' do
      confirmate_account_request(user.id, 'kamehameha')
      response_body = JSON.parse(response.body)

      expect(response_body['status']).to eq('failed')
      expect(response_body['message']).to eq('wrong token')
      expect(User.find(user.id).account_confirmed).to be(false)
    end

    it 'not confirm account - user dont exists' do
      confirmate_account_request(9999, user.confirmation_token)
      response_body = JSON.parse(response.body)

      expect(response_body['status']).to eq('failed')
      expect(response_body['message']).to eq('user not found')
      expect(User.find(user.id).account_confirmed).to be(false)
    end
  end
end
