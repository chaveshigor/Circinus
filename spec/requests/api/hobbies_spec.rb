# frozen_string_literal: true

require 'rails_helper'
require './spec/utils/auth_user'

RSpec.describe 'Api::Profiles', type: :request do
  let!(:hobby) { create(:hobby, :with_category) }
  let!(:profile) { create(:profile, :with_location, :with_user) }

  before(:each) do
    @jwt = auth_user_request(profile.user.email, 'P4ssW02d!')['jwt']
  end

  describe 'GET /index' do
    context 'When try to get all hobbies' do
      it 'return all hobbies' do
        #get '/api/hobbies'
        #response_body = JSON.parse(response.body, object_class: OpenStruct)

        p hobby
      end
    end
  end

end
