# frozen_string_literal: true

require 'rails_helper'
require './spec/utils/auth_user'

RSpec.describe 'Api::Matches', type: :request do
  let!(:user_receiver) { create(:user, first_name: 'Mikasa', last_name: 'Ackerman') }
  let!(:user_example) { create(:user, first_name: 'Levi', last_name: 'Ackerman') }

  let!(:profile_sender) { create(:profile, :with_location, :with_user) }
  let!(:profile_receiver) { create(:profile, :with_location, user: user_receiver) }
  let!(:profile_example) { create(:profile, :with_location, user: user_example) }

  def get_matches_request(jwt=@jwt)
    get '/api/matches', headers: { Authorization: jwt }
  end

  def delete_match_request(match_id, jwt=@jwt)
    delete "/api/matches/#{match_id}", headers: { Authorization: jwt }
  end

  before(:each) do
    @jwt = auth_user_request(profile_sender.user.email, 'P4ssW02d!')['jwt']
  end

  describe 'GET /index' do
    context 'When user try to list their matches' do
      it 'return all matches' do
        Match.create(profile_1_id: profile_receiver.id, profile_2_id: profile_sender.id)
        Match.create(profile_1_id: profile_sender.id, profile_2_id: profile_example.id)
        
        get_matches_request
        response_body = JSON.parse(response.body, object_class: OpenStruct)

        expect(response_body.matches.count).to eq(2)
        expect(response_body.matches.to_json).to include(profile_receiver.to_json)
        expect(response_body.matches.to_json).to include(profile_example.to_json)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'When user try to delete a match' do
      it 'delete the match' do
        match = Match.create(profile_1_id: profile_receiver.id, profile_2_id: profile_sender.id)

        expect{ delete_match_request(match.id) }.to change { Match.count }.by(-1)
        expect(response.status).to eq(204)
      end

      it 'does not delete an nonexistent match' do
        expect{ delete_match_request('99999') }.to change { Match.count }.by(0)
        expect(response.status).to eq(404)
      end
    end
  end
end
