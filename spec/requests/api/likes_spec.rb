# frozen_string_literal: true

require 'rails_helper'
require './spec/utils/auth_user'

RSpec.describe 'Api::Likes', type: :request do
  let!(:state) { create(:state) }
  let!(:city) { create(:city, state: state) }

  let!(:user_sender) { create(:user) }
  let!(:user_receiver) { create(:user, first_name: 'Mikasa', last_name: 'Ackerman') }
  let!(:user_example) { create(:user, first_name: 'Levi', last_name: 'Ackerman') }

  def create_like_request(jwt, user_receiver_id)
    post "/api/likes/#{user_receiver_id}", headers: { Authorization: jwt }
  end

  def get_likes_requests(jwt=@jwt)
    get '/api/likes', headers: { Authorization: jwt }
  end

  before(:each) do
    @jwt = auth_user_request(user_sender.email, 'P4ssW02d!')['jwt']
  end

  describe 'POST /create' do
    context 'When user try to like another user' do
      it 'create a new like but its not a match' do
        expect{ create_like_request(@jwt, user_receiver.id) }.to change(Like, :count).by(1)
        response_body = JSON.parse(response.body, object_class: OpenStruct)

        expect(response_body.is_match).to eq(false)
        expect(response_body.like.user_sender_id).to eq(user_sender.id)
        expect(response_body.like.user_receiver_id).to eq(user_receiver.id)
      end

      it 'create a new like and it is a match' do
        Like.create(user_receiver_id: user_sender.id, user_sender_id: user_receiver.id)

        expect{ create_like_request(@jwt, user_receiver.id) }.to change(Like, :count).by(1)
        response_body = JSON.parse(response.body, object_class: OpenStruct)

        expect(response_body.is_match).to eq(true)
        expect(response_body.like.user_sender_id).to eq(user_sender.id)
        expect(response_body.like.user_receiver_id).to eq(user_receiver.id)
      end

      it 'not like the same user twice' do
        Like.create(user_receiver_id: user_receiver.id, user_sender_id: user_sender.id)

        expect{ create_like_request(@jwt, user_receiver.id) }.to change(Like, :count).by(0)
        response_body = JSON.parse(response.body, object_class: OpenStruct)
        
        expect(response_body.like.user_sender_id).to eq(user_sender.id)
        expect(response_body.like.user_receiver_id).to eq(user_receiver.id)
      end
    end
    
    context 'When user try to see all likes received' do
      it 'show all likes' do
        Like.create(user_receiver_id: user_sender.id, user_sender_id: user_receiver.id)
        Like.create(user_receiver_id: user_sender.id, user_sender_id: user_example.id)

        get_likes_requests
        response_body = JSON.parse(response.body, object_class: OpenStruct)

        expect(response_body.likes.count).to eq(2)
        expect(response_body.likes).to match(JSON.parse(Like.all.to_json, object_class: OpenStruct))
      end
    end
  end
end
