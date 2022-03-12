# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    born { Date.new(1999, 12, 13) }
    description { 'I love to read the Jirayas books' }
  end
end
