# frozen_string_literal: true

require 'rails_helper'
require './spec/utils/auth_user'

RSpec.describe 'Api::Profiles', type: :request do
  let!(:hobby) { create(:hobby, :with_category) }
  let!(:user) { create(:user) }
  let!(:profile) { create(:profile, :with_location, user: user) }

  before(:each) do
    @jwt = auth_user_request(user.email, 'P4ssW02d!')['jwt']
  end

  def show_all_hobby_categories_requests(jwt)
    get '/api/hobby_categories', headers: { Authorization: jwt }
  end

  def show_hobby_category(jwt, category_id)
    get "/api/hobby_categories/#{category_id}", headers: { Authorization: jwt }
  end

  describe 'GET /index' do
    context 'When try to get all hobby categories' do
      it 'return all hobby categories' do
        show_all_hobby_categories_requests(@jwt)
        response_body = JSON.parse(response.body)

        hobby_categories = HobbyCategory.all
        hobby_categories = Api::HobbyCategorySerializer.new(hobby_categories)
        hobby_categories = JSON.parse(hobby_categories.to_json)

        expect(response_body['hobby_categories']).to eq(hobby_categories)
        expect(response.status).to be(200)
      end

      it 'dont return hobby categories when the user is not logged' do
        show_all_hobby_categories_requests('')

        expect(response.status).to be(401)        
      end
    end
  end

  describe 'GET /show' do
    context 'When try to get category info' do
      it 'show info about a hobby category' do
        show_hobby_category(@jwt, hobby.hobby_category_id)
        response_body = JSON.parse(response.body)

        hobby_category = hobby.hobby_category
        hobby_category_serialized = Api::HobbyCategorySerializer.new(hobby_category)
        hobby_category_serialized = JSON.parse(hobby_category_serialized.to_json)
        
        expect(response.status).to be(200)
        expect(response_body['hobby_category']).to eq(hobby_category_serialized)
      end
    end
  end

end
