# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    amount { Faker::Number.number(digits: 3) }
    user
    status { :pending }
  end

  trait :default_country do
    country { 'US' }
  end

  trait :other_country do
    country { Faker::Address.country }
  end
end
