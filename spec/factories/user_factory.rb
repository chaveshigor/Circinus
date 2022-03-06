# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { 'eren' }
    last_name { 'yeager' }
    email { "#{first_name}_#{last_name}@example.com" }
    password_digest { 'P4ssW02d!' }
  end
end
