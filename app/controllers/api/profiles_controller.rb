class Api::ProfilesController < Api::ApiController
  before_action :authorize_request
  before_action :check_city, only: %i[create update]

  def index
    current_user_city = City.find(@current_user.profile.city_id)
    profiles = Profile.where({ city_id: current_user_city.id }).where.not({ user_id: @current_user.id })
    render json: { status: 'success', profiles: profiles.map(&:send_profile) }
  end

  def create
    if Profile.find_by_user_id(@current_user.id).present?
      return render json: { status: 'failed', message: 'profile already exists' }
    end

    profile = Profile.new(profile_params)
    profile.user_id = @current_user.id

    return render json: { status: 'failed', message: 'erro' } if profile.invalid?

    profile.save
    render json: { status: 'success', profile: profile.send_profile }
  end

  def update
    profile = Profile.find(params[:id])
    profile.update(profile_params_edit)

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

  def profile_params_edit
    params.require(:profile_edit).permit(:id, :description, :city_id)
  end
end
