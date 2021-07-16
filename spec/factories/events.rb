# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    #   sequence(:email) { |n| "person#{n}@example.com" }
    #   password { 'password' }
    #   password_confirmation { 'password' }
    sequence(:name) { |n| "TEST_NAME#{n}" }
  end

  factory :user do
    sequence(:name) { |n| "TEST_USER_NAME#{n}" }
  end
end
