# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    #   sequence(:email) { |n| "person#{n}@example.com" }
    #   password { 'password' }
    #   password_confirmation { 'password' }
    sequence(:name) { |n| "TEST_NAME#{n}" }

    after(:create) do |event|
      create_list(:item, 3, event: event)
    end
  end

  factory :user do
    sequence(:name) { |n| "TEST_USER_NAME#{n}" }
  end

  factory :item do
    sequence(:name) { |n| "TEST_ITEM_NAME#{n}" }
    need_number { 6 }
  end
end
