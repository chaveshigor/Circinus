# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Cities', type: :request do
  let!(:state) { create(:state) }
  let!(:city1) { create(:city, state: state) }
  let!(:city2) { create(:city, name: 'Sina', state: state) }

  describe 'GET /index' do
    it 'show all cities from a state' do
      get "/api/states/#{state.id}/cities"

      response_body = JSON.parse(response.body)
      cities = response_body['cities']

      expect(cities.count).to eq(2)
      expect(cities.find { |c| c['id'] == city1.id }.present?).to be(true)
      expect(cities.find { |c| c['id'] == city2.id }.present?).to be(true)
    end

    it 'try to show cities from an unexistent state' do
      get '/api/states/99999/cities'

      response_body = JSON.parse(response.body)

      expect(response_body['status']).to eq('failed')
      expect(response_body['message']).to eq('state dont exists')
    end
  end

  describe 'GET /show' do
    it 'show the state that the city belongs to' do
      get "/api/cities/#{city1.id}"

      response_body = JSON.parse(response.body)

      expect(response_body['state']['id']).to eq(state.id)
      expect(response_body['city']['id']).to eq(city1.id)
    end
  end
end
