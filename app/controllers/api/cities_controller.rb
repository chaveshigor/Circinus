# frozen_string_literal: true


class Api::CitiesController < Api::ApiController
  def index
    state = State.find(params[:id]) rescue state = nil
    return render json: { status: 'failed', message: 'state dont exists' } if state.nil?

    cities = state.cities
    render json: { status: 'success', message: 'cities founded', cities: cities }
  end

  def show
    city = City.find(params[:id]) rescue city = nil
    return render json: { status: 'failed', message: 'city dont exists' } if city.nil?

    state = city.state
    render json: { status: 'success', message: 'city founded', city: city, state: state }
  end
end
