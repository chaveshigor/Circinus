# frozen_string_literal: true

class Api::LikesController < ApplicationController
  before_action :authorize_request

  def index
    likes = Like.where({profile_receiver_id: @current_user.profile.id})
    render json: { likes: likes }
  end

  def create
    receiver_id = like_params[:profile_receiver_id]
    liked_profile = Profile.find(receiver_id)

    if match?(receiver_id)
      create_match(receiver_id)
      return render json: { liked_profile: liked_profile, is_match: true }
    end
    
    Like.find_or_create_by({profile_sender_id: @current_user.profile.id, profile_receiver_id: receiver_id})
    render json: { liked_profile: liked_profile, is_match: false }
  end

  private

  def create_match(receiver_id)
    Match.create!({profile_1_id: @current_user.profile.id, profile_2_id: receiver_id})
    Like.find_by({profile_sender_id: receiver_id, profile_receiver_id: @current_user.profile.id}).destroy
  end

  def match?(receiver_id)
    like = Like.where({profile_sender_id: receiver_id, profile_receiver_id: @current_user.profile.id})
    like.present?
  end

  def like_params
    params.require(:like).permit(:profile_receiver_id)
  end
end
