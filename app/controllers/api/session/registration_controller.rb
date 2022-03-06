# frozen_string_literal: true

class Api::Session::RegistrationController < ApplicationController
  def create
    @new_user = User.find_by_email(new_user_params[:email])
    return render json: { status: 'failed', message: 'user already exists' } if @new_user.present?

    @new_user = User.create(new_user_params)
    render json: {
      status: 'success',
      message: 'user created',
      user: @new_user.send_user
    }
  end

  def destroy
    @user = User.find(destroy_user_params[:id]) rescue @user = nil
    return render json: { status: 'failed', message: 'user dont exists' } if @user.nil?
    return render json: { status: 'success', message: 'user deleted' } if @user.destroy

    render json: { status: 'failed', message: 'unexpected error' }
  end

  def confirmate_account
    user = User.find(params[:user_id]) rescue user = nil
    return render json: { status: 'failed', message: 'user not found' } if user.nil?
    return render json: { status: 'failed', message: 'wrong token' } if user.confirmation_token != params[:confirmation_token]

    user.account_confirmed = true if user.confirmation_token == params[:confirmation_token]
    user.save if user.confirmation_token == params[:confirmation_token]

    render json: {
      status: 'success',
      message: 'account confirmed',
      user: user.attributes.except('password_digest', 'confirmation_token')
    }
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
