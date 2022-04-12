# frozen_string_literal: true

require 'rails_helper'
require './spec/utils/auth_user'

RSpec.describe 'Api::Likes', type: :request do
  let!(:user_receiver) { create(:user, first_name: 'Mikasa', last_name: 'Ackerman') }
  let!(:user_example) { create(:user, first_name: 'Levi', last_name: 'Ackerman') }

  let!(:profile_sender) { create(:profile, :with_location, :with_user) }
  let!(:profile_receiver) { create(:profile, :with_location, user: user_receiver) }
  let!(:profile_example) { create(:profile, :with_location, user: user_example) }

  def create_like_request(jwt, profile_receiver_id)
    post '/api/likes/', 
    params: { 
      like: { profile_receiver_id: profile_receiver_id }
    }, 
    headers: { Authorization: jwt }
  end

  def get_likes_requests(jwt=@jwt)
    get '/api/likes', headers: { Authorization: jwt }
  end

  before(:each) do
    @jwt = auth_user_request(profile_sender.user.email, 'P4ssW02d!')['jwt']
  end

  describe 'POST /create' do
    context 'When user try to like another user' do
      context 'when it is not a match' do
        it 'create a new like' do
          expect{ create_like_request(@jwt, profile_receiver.id) }.to change(Like, :count).by(1)
          response_body = JSON.parse(response.body, object_class: OpenStruct)
  
          expect(response_body.is_match).to eq(false)
          expect(response_body.liked_profile.id).to eq(profile_receiver.id)
        end
        
        it 'not like the same user twice' do
          Like.create(profile_receiver_id: profile_receiver.id, profile_sender_id: profile_sender.id)
  
          expect{ create_like_request(@jwt, profile_receiver.id) }.to change(Like, :count).by(0)
          response_body = JSON.parse(response.body, object_class: OpenStruct)
          
          expect(response_body.is_match).to eq(false)
          expect(response_body.liked_profile.id).to eq(profile_receiver.id)
        end
      end

      context 'when its a match' do
        it 'delete received like and create the match' do
          Like.create(profile_receiver_id: profile_sender.id, profile_sender_id: profile_receiver.id)
  
          expect{ create_like_request(@jwt, profile_receiver.id) }.to change(Match, :count).by(1)
          response_body = JSON.parse(response.body, object_class: OpenStruct)
  
          expect(response_body.is_match).to eq(true)
          expect(response_body.liked_profile.id).to eq(profile_receiver.id)
        end
      end
    end
  end
  
  describe 'GET /show' do
    context 'When user try to see all likes received' do
      it 'show all likes' do
        Like.create(profile_receiver_id: profile_sender.id, profile_sender_id: profile_receiver.id)
        Like.create(profile_receiver_id: profile_sender.id, profile_sender_id: profile_example.id)
  
        get_likes_requests
        response_body = JSON.parse(response.body, object_class: OpenStruct)
  
        expect(response_body.likes.count).to eq(2)
        expect(response_body.likes).to match(JSON.parse(Like.all.to_json, object_class: OpenStruct))
      end
    end
  end
end
