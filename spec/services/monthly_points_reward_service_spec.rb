# frozen_string_literal: true

require "rails_helper"

RSpec.describe Rewards::MonthlyPointsRewardService, type: :service do
  describe "monthly points reward service call" do
    let(:user) { create(:user, date_of_birth: 30.year.ago - 1.month) }

    before do
      allow(Time).to receive(:current).and_return(Time.current)
    end

    it "grants reward if points >= threshold and not already issued" do
      create_list(:transaction, 2, :default_country, user: user, amount: 500, status: :processed)
      expect {
        described_class.call(user)
      }.to change { user.rewards.count }.by(1)

      expect(user.rewards.last).to have_attributes(
          reward_type: "free_coffee",
          message: "monthly_points",
          issued_on: Time.current.to_date
      )
    end

    it "does not grant reward if already issued" do
      create_list(:transaction, 2, :default_country, user: user, amount: 500, status: :processed)
      create(:reward, user: user, reward_type: "free_coffee", message: "monthly_points", issued_on: Time.current.to_date)

      expect {
        described_class.call(user)
      }.not_to change { user.rewards.count }
    end

    it "does not grant reward if points below threshold" do
      create(:transaction, :default_country, user: user, amount: 500, status: :processed)

      expect {
        described_class.call(user)
      }.not_to change { user.rewards.count }
    end
  end
end
