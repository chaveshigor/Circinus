# frozen_string_literal: true

class Api::ApiController < ApplicationController
  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(token)
      @current_user = User.find(@decoded[:data])
    rescue ActiveRecord::RecordNotFound => e
      unauthorized_request(e.message)
    rescue JWT::DecodeError => e
      unauthorized_request(e.message)
    end
  end

  def unauthorized_request(message = 'unauthorized request')
    render json: { status: 'unauthorized', message: message }, status: :unauthorized
  end

  def not_found_request(message='entity not found')
    render json: { status: 'not found', message: message }, status: :not_found
  end

  def forbidden_request(message='forbidden access')
    render json: { status: 'forbidden', message: message }, status: :forbidden
  end
end