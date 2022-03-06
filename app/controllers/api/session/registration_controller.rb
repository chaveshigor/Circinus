# frozen_string_literal: true

class Api::Session::RegistrationController < ApplicationController
  def create
    @new_user = User.find_by_email(new_user_params[:email])
    return render json: { status: 'failed', message: 'user already exists' } if @new_user.present?

    @new_user = User.create(new_user_params)
    render json: { 
      status: 'success',
      message: 'user created',
      user: @new_user.attributes.except('password_digest', 'confirmation_token')
    }
  end

  def destroy
    @user = User.find(destroy_user_params[:id]) rescue @user = nil
    return render json: { status: 'failed', message: 'user dont exists' } if @user.nil?
    return render json: { status: 'success', message: 'user deleted' } if @user.destroy

    render json: { status: 'failed', message: 'unexpected error' }
  end

  private

  def new_user_params
    params.require(:new_user)
          .permit(:first_name, :last_name, :email, :password_digest)
  end

  def destroy_user_params
    params.require(:user_to_delete).permit(:id)
  end
end
