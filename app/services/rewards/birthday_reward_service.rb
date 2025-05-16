# frozen_string_literal: true

module Rewards
  class BirthdayRewardService
    REWARD_MESSAGE = "birthday".freeze

    def self.call(user)
      return unless eligible?(user)

      Reward.create_reward(
        user: user,
        type: :free_coffee,
        message: REWARD_MESSAGE
      )
    end

    def self.eligible?(user)
      current_month = Time.current.month

      user.date_of_birth.month == current_month &&
        user.rewards.issued_this_month(:free_coffee, REWARD_MESSAGE).none?
    end
  end
end
