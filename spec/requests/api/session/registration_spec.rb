# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::States', type: :request do
  let!(:user) { create(:user) }

  def create_user_request
    post '/api/session/registration', params: {
      new_user: {
        first_name: 'son',
        last_name: 'goku',
        email: 'son_goku@example.com',
        password_digest: '12345678'
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
    it 'create a new user' do
      create_user_request
      new_user = JSON.parse(response.body)

      expect(new_user['status']).to eq('success')
      expect(new_user['message']).to eq('user created')

      new_user = User.find(new_user['user']['id'])
      expect(new_user.confirmation_token.present?).to be(true)
    end

    it 'not create a user with an existent email' do
      create_user_request
      create_user_request
      new_user = JSON.parse(response.body)

      expect(new_user['status']).to eq('failed')
      expect(new_user['message']).to eq('user already exists')
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
