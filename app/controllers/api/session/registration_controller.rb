# frozen_string_literal: true

class Api::Session::RegistrationController < Api::ApiController
  skip_before_action :verify_authenticity_token
  before_action :authorize_request, only: %i[destroy]

  def create
    user = User.find_by_email(new_user_params[:email])
    return forbidden_request('user already exists') if user.present?

    new_user = User.create(new_user_params)
    new_profile = create_profile(new_user, new_profile_params)

    render json: { user: new_user.send_user, profile: new_profile }, status: :created
  end

  def destroy
    user = @current_user
    profile = user.profile

    profile.destroy
    user.destroy

    render json: { }, status: 204
  end

  def confirmate_account
    user = User.find(params[:user_id]) rescue user = nil

    return not_found_request('user not found') if user.nil?
    return unauthorized_request('wrong token') if user.confirmation_token != params[:confirmation_token]

    if user.confirmation_token == params[:confirmation_token]
      user.account_confirmed = true
      user.save
    end

    render json: {
      user: user.attributes.except('password_digest', 'confirmation_token')
    }
  end

  private

  def create_profile(user, new_profile_params)
    profile_params = new_profile_params
    profile_params[:user_id] = user.id

    Profile.create(profile_params)
  end

  def new_profile_params
    params.require(:new_profile)
          .permit(:born, :description, :city_id)
  end

  def new_user_params
    params.require(:new_user)
          .permit(:first_name, :last_name, :email, :password_digest)
  end
end
