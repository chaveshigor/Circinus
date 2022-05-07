# frozen_string_literal: true

class Api::MatchesController < Api::ApiController
  before_action :authorize_request

  def index
    current_profile_id = @current_user.profile.id
    match_profiles_ids = Match.profile_matches(current_profile_id)
    matches = get_matches(match_profiles_ids, current_profile_id)

    render json: { matches: matches }
  end

  def destroy
    match_id = params[:id]

    match = Match.find(match_id) rescue match = nil
    return render json: { }, status: :not_found if match.nil?

    match.destroy
    render json: { }, status: 204
  end

  private

  def get_matches(match_profiles_ids, current_profile_id)
    matches = []
    match_profiles_ids.each do |match_profile|
      if match_profile.profile_1_id != current_profile_id
        matches << Profile.find(match_profile.profile_1_id)
        next
      end
      matches << Profile.find(match_profile.profile_2_id) if match_profile.profile_2_id != current_profile_id
    end

    matches
  end
end
