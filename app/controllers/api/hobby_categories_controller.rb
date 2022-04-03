# frozen_string_literal: true

class Api::HobbyCategoriesController < ApplicationController
  before_action :authorize_request

  def index
    hobby_categories = HobbyCategory.all
    render json: { hobby_categories: Api::HobbyCategorySerializer.new(hobby_categories) }
  end

  def show
    hobby_category = HobbyCategory.find(params[:id])
    render json: { hobby_category: Api::HobbyCategorySerializer.new(hobby_category) }
  end
end
