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

  before(:each) do
    @jwt = auth_user_request(profile_sender.user.email, 'P4ssW02d!')['jwt']
  end

  describe 'GET /index' do
    context "When user try to list their matches" do
      it 'create a new match' do
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
end
