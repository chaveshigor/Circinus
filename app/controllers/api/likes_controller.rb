# frozen_string_literal: true

class Api::LikesController < ApplicationController
  before_action :authorize_request

  def show
    likes = Like.where({user_receiver_id: @current_user.id})
    render json: { likes: likes }
  end

  def create
    create_match if match?(params[:user_receiver_id])
    new_like = Like.create({user_sender_id: @current_user.id, user_receiver_id: params[:user_receiver_id]})
    render json: { like: new_like }
  end

  private 

  def create_match
    
  end

  def match?(receiver_id)
    like = Like.where({user_sender_id: receiver_id, user_receiver_id: @current_user.id})
    like.present?
  end
end
