class Api::ProfilesController < Api::ApiController
  before_action :authorize_request
  before_action :check_city, only: %i[update]

  def index
    current_user_city = City.find(@current_user.profile.city_id)
    profiles = Profile.where({ city_id: current_user_city.id }).where.not({ user_id: @current_user.id })
    render json: { status: 'success', profiles: Api::ProfileSerializer.new(profiles).serializable_hash }
  end

  def update
    profile = Profile.find(params[:id])
    profile.update(edit_profile_params)

    render json: { status: 'success', profile: profile }
  end

  private

  def check_city
    City.find(profile_params[:city_id])
  rescue ActiveRecord::RecordNotFound
    render json: { status: 'failed', message: 'city not found' }
  end

  def profile_params
    params.require(:profile).permit(:born, :description, :city_id)
  end

  def edit_profile_params
    params.require(:profile_edit).permit(:id, :description, :city_id)
  end
end
