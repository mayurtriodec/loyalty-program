# frozen_string_literal: true

module Rewards
  class UserSpendRewardService
    SPEND_THRESHOLD = 1000
    DAYS_WINDOW = 60
    REWARD_MESSAGE = "new_user_spend".freeze

    def self.call(user)
      return unless eligible?(user)

      Reward.create_reward(
        user: user,
        type: :free_movie_tickets,
        message: REWARD_MESSAGE
      )
    end

    def self.eligible?(user)
      return false unless (first_transaction_date = user.first_transaction_date)

      spending_window = first_transaction_date..(first_transaction_date + DAYS_WINDOW.days)

      total_spent = user.transactions.processed
                      .joins(:user)
                      .where(created_at: spending_window)
                      .sum("amount * CASE WHEN transactions.country = users.country THEN 1.0 ELSE 2.0 END")

      total_spent >= SPEND_THRESHOLD &&
        user.rewards.where(
          reward_type: :free_movie_tickets,
          message: "new_user_spend"
        ).none?
    end
  end
end
