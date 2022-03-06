# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::States', type: :request do
  describe 'GET /index' do
    it 'show all states' do
      get '/api/states'

      all_states = JSON.parse(response.body)
      number_of_states = State.all.count
      expect(all_states.count).to eq(number_of_states)
    end
  end
end
