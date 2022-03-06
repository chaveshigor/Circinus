# frozen_string_literal: true


class Api::CitiesController < ApplicationController
  def index
    state = State.find(params[:id]) rescue state = nil
    return render json: { status: 'failed', message: 'state dont exists' } if state.nil?

    @cities = state.cities
    render json: { status: 'success', message: 'cities founded', cities: @cities }
  end
end
