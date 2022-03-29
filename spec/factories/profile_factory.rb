# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    born { Date.new(1999, 12, 13) }
    description { 'I love to read the Jirayas books' }

    trait :with_location do
      before(:create) do |profile|
        profile.city = create(:city, :with_state)
      end
    end

    trait :with_user do
      before(:create) do |profile|
        profile.user = create(:user)
      end
    end
  end
end
