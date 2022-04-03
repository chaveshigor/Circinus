# frozen_string_literal: true

class Api::HobbyCategoriesController < ApplicationController
  before_action :authorize_request

  def index
    hobby_categories = HobbyCategory.all
    render json: { hobby_categories: Api::HobbyCategorySerializer.new(hobby_categories) }
  end

  def show
    hobby_category = HobbyCategory.find(params[:id]) rescue hobby_category = nil
    return render json: { status: 'failed', message: 'hobby category dont exists' }, status: :not_found if hobby_category.nil?
    render json: { hobby_category: Api::HobbyCategorySerializer.new(hobby_category) }
  end
end
