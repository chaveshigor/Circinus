# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::States', type: :request do
  let!(:user) { create(:user) }

  def auth_user_request(email, password)
    post '/api/session/auth', params: {
      user: {
        email: email,
        password: password
      }
    }
  end

  describe 'POST /create' do
    it 'auth the user' do
      auth_user_request(user.email, 'P4ssW02d!')
      response_body = JSON.parse(response.body)

      expect(response_body['status']).to eq('success')
      expect(response_body['message']).to eq('user authenticated')
      expect(response_body['jwt'].present?).to be(true)
      expect(response_body['user']['id']).to eq(user.id)
      expect(response_body['user']['password_digest'].present?).to be(false)
      expect(response_body['user']['confirmation_token'].present?).to be(false)
      expect(JsonWebToken.decode(response_body['jwt'])['data']).to eq(user.id)
    end

    it 'try to auth user with wrong pass' do
      auth_user_request(user.email, 'kamehameha')
      response_body = JSON.parse(response.body)

      expect(response_body['status']).to eq('failed')
      expect(response_body['message']).to eq('authentication failed')
    end

    it 'try to auth user with wrong email' do
      auth_user_request('eren_s2_mikasa@example.com', 'P4ssW02d!')
      response_body = JSON.parse(response.body)

      expect(response_body['status']).to eq('failed')
      expect(response_body['message']).to eq('authentication failed')
    end
  end
end
