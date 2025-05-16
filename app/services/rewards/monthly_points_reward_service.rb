# frozen_string_literal: true

module Rewards
  class MonthlyPointsRewardService
    POINTS_THRESHOLD = 100
    REWARD_MESSAGE = "monthly_points".freeze

    def self.call(user)
      return unless eligible?(user)

      Reward.create_reward(
        user: user,
        type: :free_coffee,
        message: REWARD_MESSAGE
      )
    end

    def self.eligible?(user)
      monthly_points = user.monthly_transaction_points

      monthly_points >= POINTS_THRESHOLD &&
        user.rewards.issued_this_month(:free_coffee, REWARD_MESSAGE).none?
    end
  end
end
