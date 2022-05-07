class Api::ProfilesController < Api::ApiController
  before_action :authorize_request
  before_action :check_city, only: %i[update]

  def index
    profiles = Profile.except_current_profile(@current_user).from_same_city(@current_user).unseen_profiles.limit(10)
    profiles.each do |profile|
      profile.pictures.each do |picture|
        picture.url = S3::ShowService.new(picture.storage_service_key).run
      end
    end

    render json: Api::ProfileSerializer.new(profiles)
  end

  def update
    begin
      profile = Profile.find(@current_user.profile.id)
      profile.update(edit_profile_params)

      ProfileImages::AddPicturesService.new(params[:add_pictures], profile).run if params[:add_pictures].present?
      ProfileImages::DestroyPicturesService.new(params[:destroy_pictures]).run  if params[:destroy_pictures].present?
      ProfileImages::MovePicturesService.new(params[:move_pictures]).run        if params[:move_pictures].present?

    rescue ActiveRecord::RecordNotFound, StandardError => e
      return not_found_request(e.message)
    end

    render json: Api::ProfileSerializer.new(profile)
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
