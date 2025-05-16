# frozen_string_literal: true

module Loyalty
  class PointsService
    def initialize(transaction)
      @transaction = transaction
      @user = transaction.user
    end

    def process
      return unless valid_transaction?

      points = calculate_points
      award_points(points)

      # Check if the user qualifies for additional spend based rewards
      Rewards::UserSpendRewardService.call(@user)
    end

    private

    def valid_transaction?
      @transaction.processed? && @user.present?
    end

    def calculate_points
      base_points = @transaction.amount * Reward::BASE_MULTIPLIER
      multiplier = international_transaction? ? Reward::INTERNATIONAL_MULTIPLIER : Reward:: LOCAL_MULTIPLIER
      (base_points * multiplier)
    end

    def international_transaction?
      @transaction.country != @user.country
    end

    def award_points(points)
      @user.with_lock do
        @user.increment!(:loyalty_points, points)
      end
    end
  end
end
