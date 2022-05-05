# frozen_string_literal: true

FactoryBot.define do
  factory :picture do
    storage_service_key { 'random_key' }
    position { '0' }

    trait :with_profile do
      before(:create) do |picture|
        picture.profile = create(:profile)
      end
    end
  end
end
