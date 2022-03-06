# frozen_string_literal: true

class Api::Session::AuthController < ApplicationController
  def create
    user = User.find_by_email(auth_user_params[:email]) rescue user = nil
    return render json: { status: 'failed', message: 'authentication failed' } if user.nil?
    unless password_correct?(user, auth_user_params[:password])
      return render json: { status: 'failed', message: 'authentication failed' }
    end

    render json: {
      status: 'success',
      message: 'user authenticated',
      jwt: JsonWebToken.encode(user.id),
      user: user.send_user
    }
  end

  private

  def auth_user_params
    params.require(:user).permit(:email, :password)
  end

  def password_correct?(user, pass)
    BCrypt::Password.new(user.password_digest) == pass
  end
end
