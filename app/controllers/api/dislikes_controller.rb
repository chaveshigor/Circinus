# frozen_string_literal: true

class Api::DislikesController < Api::ApiController
  before_action :authorize_request

  def create
    receiver_id = dislike_params[:profile_receiver_id]

    Dislike.find_or_create_by({ profile_sender_id: @current_user.profile.id, profile_receiver_id: receiver_id })
    render json: { }
  end

  private

  def dislike_params
    params.require(:dislike).permit(:profile_receiver_id)
  end
end
