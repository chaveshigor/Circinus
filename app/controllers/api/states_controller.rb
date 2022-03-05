# frozen_string_literal: true

module Api
  class StatesController < ApplicationController
    def index
      all_states = State.all

      render json: all_states.to_json
    end
  end
end
