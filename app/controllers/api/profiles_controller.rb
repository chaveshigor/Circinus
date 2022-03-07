class Api::ProfilesController < ApplicationController
  before_action :authorize_request

  def index
    current_user_city = City.find(@current_user.profile.city_id)
    profiles = Profile.where({ city_id: current_user_city.id })
    profiles.delete(@current_user.profile)
    render json: { status: 'success', profiles: profiles }
  end

  def create
    city = City.find(profile_params[:city_id]) rescue user = nil
    return render json: { status: 'failed', message: 'city not found' } if city.nil?

    profile = Profile.new(profile_params)
    profile.user_id = @current_user.id
    profile.save
    render json: { status: 'success', profile: profile.send_profile }
  end

  def update

  end

  private

  def profile_params
    params.require(:profile).permit(:born, :description, :city_id)
  end
end
