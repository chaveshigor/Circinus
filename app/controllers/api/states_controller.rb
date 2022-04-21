# frozen_string_literal: true

class Api::StatesController < Api::ApiController
  def index
    all_states = State.all

    render json: all_states.to_json
  end
end
