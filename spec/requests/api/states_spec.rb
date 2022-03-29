# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::States', type: :request do
  let!(:state1) { create(:state) }
  let!(:state2) { create(:state, name: 'Gothan', uf: 'GT') }
  let!(:state3) { create(:state, name: 'Kings Landing', uf: 'KL') }

  describe 'GET /index' do
    context 'When get all states' do
      it 'show all states' do
        get '/api/states'
  
        all_states = JSON.parse(response.body)
        number_of_states = State.all.count
  
        expect(all_states.count).to eq(number_of_states)
        expect(State.find(state1.id)).to eq(state1)
        expect(State.find(state2.id)).to eq(state2)
        expect(State.find(state3.id)).to eq(state3)
      end
    end
  end
end
