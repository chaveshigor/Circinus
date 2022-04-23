class Api::ProfilesController < Api::ApiController
  before_action :authorize_request
  before_action :check_city, only: %i[update]

  def index
    current_user_city = City.find(@current_user.profile.city_id)
    profiles = Profile.where({ city_id: current_user_city.id }).where.not({ user_id: @current_user.id })

    render json: { status: 'success', profiles: Api::ProfileSerializer.new(profiles).serializable_hash }
  end

  def update
    begin
      profile = Profile.find(@current_user.profile.id)
      profile.update(edit_profile_params)

      ProfileImages::AddPicturesService.new(params[:add_pictures], profile).run if params[:add_pictures].present?
      ProfileImages::DestroyPicturesService.new(params[:destroy_pictures]).run  if params[:destroy_pictures].present?
      ProfileImages::MovePicturesService.new(params[:move_pictures]).run        if params[:move_pictures].present?
    rescue ActiveRecord::RecordNotFound => e
      return not_found_request(e.message)
    end

    render json: { status: 'success', profile: Api::ProfileSerializer.new(profile).serializable_hash[:data][:attributes] }
  end

  private

  def check_city
    City.find(edit_profile_params[:city_id])
  rescue ActiveRecord::RecordNotFound
    not_found_request('city not found')
  end

  def edit_profile_params
    params.require(:profile_edit).permit(:description, :city_id)
  end
end
