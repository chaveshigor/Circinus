# frozen_string_literal: true

require 'rails_helper'
require './spec/utils/auth_user'

RSpec.describe 'Api::Dislikes', type: :request do
  let!(:user_receiver) { create(:user, first_name: 'Mikasa', last_name: 'Ackerman') }
  let!(:user_example) { create(:user, first_name: 'Levi', last_name: 'Ackerman') }

  let!(:profile_sender) { create(:profile, :with_location, :with_user) }
  let!(:profile_receiver) { create(:profile, :with_location, user: user_receiver) }
  let!(:profile_example) { create(:profile, :with_location, user: user_example) }

  def create_dislike_request(jwt, profile_receiver_id)
    post '/api/dislikes/',
         params:  {
           dislike: { profile_receiver_id: profile_receiver_id }
         },
         headers: { Authorization: jwt }
  end

  before(:each) do
    @jwt = auth_user_request(profile_sender.user.email, 'P4ssW02d!')['jwt']
  end

  describe 'POST /create' do
    it 'give a dislike to an user' do
      expect { create_dislike_request(@jwt, profile_receiver.id) }.to change(Dislike, :count).by(1)
    end
  end
end
