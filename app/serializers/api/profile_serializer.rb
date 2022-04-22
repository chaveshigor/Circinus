# frozen_string_literal: true

class Api::ProfileSerializer < AplicationSerializer
  attributes :id, :born, :description, :city_id, :user_id, :pictures
end
