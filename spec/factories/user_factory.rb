# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    date_of_birth { Faker::Date.in_date_period }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    country { 'US' }
  end
end
