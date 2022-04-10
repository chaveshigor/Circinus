# frozen_string_literal: true

class Api::LikesController < ApplicationController
  before_action :authorize_request

  def show
    likes = Like.where({user_receiver_id: @current_user.id})
    render json: { likes: likes }
  end

  def create
    receiver_id = params[:user_receiver_id].to_i

    new_like = Like.find_or_create_by({user_sender_id: @current_user.id, user_receiver_id: receiver_id})
    render json: { like: new_like, is_match: match?(receiver_id) }
  end

  private

  def match?(receiver_id)
    like = Like.where({user_sender_id: receiver_id, user_receiver_id: @current_user.id})
    like.present?
  end
end
