# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'john@example.com' }
    password_digest { 'P4ssW02d!' }
  end
end
