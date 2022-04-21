# frozen_string_literal: true

class Api::ApiController < ApplicationController
  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(token)
      @current_user = User.find(@decoded[:data])
    rescue ActiveRecord::RecordNotFound => e
      render json: { status: 'unauthorized', message: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { status: 'unauthorized', message: e.message }, status: :unauthorized
    end
  end

  def unauthorized_request(message = 'unauthorized request')
    render json: { status: 'unauthorized', message: message }, status: :unauthorized
  end

  def not_found(message='entity not found')
    render json: { status: 'not found', message: message }, status: :not_found
  end

  def forbidden(message='forbidden access')
    render json: { status: 'forbidden', message: message }, status: :forbidden
  end
end