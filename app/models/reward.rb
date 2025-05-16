# frozen_string_literal: true

class Reward < ApplicationRecord
  BASE_MULTIPLIER = 0.1
  INTERNATIONAL_MULTIPLIER = 2.0
  LOCAL_MULTIPLIER = 1.0

  belongs_to :user, inverse_of: :rewards

  validates :reward_type, presence: true
  validates :issued_on, presence: true

  enum :reward_type, {
    free_coffee: "free_coffee",
    free_movie_tickets: "free_movie_tickets"
  }, prefix: :reward_type

  scope :issued_this_month, ->(type, message = nil) {
    where(
      reward_type: reward_types[type],
      message: message,
      issued_on: Time.current.all_month
    )
  }

  class << self
    def create_reward(user:, type:, message:)
      create!(
        user: user,
        reward_type: type,
        message: message,
        issued_on: Date.current
      )
    end
  end
end
