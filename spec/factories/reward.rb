# frozen_string_literal: true

FactoryBot.define do
  factory :reward do
    user
    reward_type { %w[free_movie_tickets free_coffee].sample }
    message { %w[new_user_spend monthly_points birthday].sample }
    issued_on { Date.today }
  end
end
