# frozen_string_literal: true

require 'rails_helper'
require 'json'

RSpec.describe 'Api::States', type: :request do
  describe 'GET /index' do
    it 'show all states' do
      get '/api/states'

      all_states = JSON.parse(response.body)
      expect(all_states.count).to eq(27)
    end
  end
end
