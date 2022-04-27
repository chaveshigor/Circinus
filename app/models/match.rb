# frozen_string_literal: true

class Match < ApplicationRecord
  belongs_to :profile_1, class_name: :Profile
  belongs_to :profile_2, class_name: :Profile

  scope :profile_matches, -> (current_profile_id) { Match.select('id', 'profile_1_id', 'profile_2_id').where(profile_1_id: current_profile_id).or(Match.where(profile_2_id: current_profile_id)) }  
end
