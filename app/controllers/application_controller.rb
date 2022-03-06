# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(token)
      @current_user = User.find(@decoded[:data])
    rescue ActiveRecord::RecordNotFound => e
      render json: { status: 'failed', message: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { status: 'failed', message: e.message }, status: :unauthorized
    end
  end
end
