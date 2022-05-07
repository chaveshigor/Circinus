# frozen_string_literal: true

FactoryBot.define do
  factory :city do
    name { 'Maria' }

    trait :with_state do
      before(:create) do |city|
        city.state = create(:state)
      end
    end
  end
end
