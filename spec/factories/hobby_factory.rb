# frozen_string_literal: true

FactoryBot.define do
  factory :hobby do
    name { 'Fight' }

    trait :with_category do
      before(:create) do |hobby|
        hobby.hobby_category = create(:hobby_category)
      end
    end
  end
end
