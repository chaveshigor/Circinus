# frozen_string_literal: true

require 'rails_helper'
require './spec/utils/auth_user'

RSpec.describe 'Api::Likes', type: :request do
  let!(:state) { create(:state) }
  let!(:city) { create(:city, state: state) }

  let!(:user_sender) { create(:user) }
  let!(:user_receiver) { create(:user, first_name: 'Mikasa', last_name: 'Ackerman') }

  def create_like_request(jwt, user_receiver_id)
    post "/api/likes/#{user_receiver_id}", headers: { Authorization: jwt }
  end

  before(:each) do
    @jwt = auth_user_request(user_sender.email, 'P4ssW02d!')['jwt']
  end

  describe 'POST /create' do
    context "When user try to like another user" do
      it 'create a new like' do
        expect{ create_like_request(@jwt, user_receiver.id) }.to change(Like, :count).by(1)
        response_body = JSON.parse(response.body, object_class: OpenStruct)

        expect(response_body.like.user_sender_id).to eq(user_sender.id)
        expect(response_body.like.user_receiver_id).to eq(user_receiver.id)
      end
    end   
  end
end
