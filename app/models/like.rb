# frozen_string_literal: true

class Like < ApplicationRecord
  belongs_to :profile_sender, class_name: :Profile
  belongs_to :profile_receiver, class_name: :Profile
end
