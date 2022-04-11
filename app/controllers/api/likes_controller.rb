# frozen_string_literal: true

class Api::LikesController < ApplicationController
  before_action :authorize_request

  def index
    likes = Like.where({user_receiver_id: @current_user.id})
    render json: { likes: likes }
  end

  def create
    receiver_id = like_params[:user_receiver_id]
    liked_user = User.find(receiver_id)

    if match?(receiver_id)
      create_match(receiver_id)
      return render json: { liked_user: liked_user, is_match: true }
    end
    
    Like.find_or_create_by({user_sender_id: @current_user.id, user_receiver_id: receiver_id})
    render json: { liked_user: liked_user, is_match: false }
  end

  private

  def create_match(receiver_id)
    Match.create({user_1_id: @current_user.id, user_2_id: receiver_id})
    Like.find_by({user_sender_id: receiver_id, user_receiver_id: @current_user.id}).destroy
  end

  def match?(receiver_id)
    like = Like.where({user_sender_id: receiver_id, user_receiver_id: @current_user.id})
    like.present?
  end

  def like_params
    params.require(:like).permit(:user_receiver_id)
  end
end
