# frozen_string_literal: true

class Api::ProfileSerializer < AplicationSerializer
  attributes :id, :description, :city_id, :user_id, :pictures
  
  attribute :age do |object|
    object.calculate_age
  end

  attribute :full_name do |object|
    object.user.full_name
  end
end
