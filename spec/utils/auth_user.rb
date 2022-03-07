# frozen_string_literal: true

require 'rails_helper'

def auth_user_request(email, password)
  post '/api/session/auth', params: {
    user: {
      email: email,
      password: password
    }
  }

  JSON.parse(response.body)
end
