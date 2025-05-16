# frozen_string_literal: true

require "rails_helper"

RSpec.describe Rewards::UserSpendRewardService, type: :service do
  describe "user spend reward service call" do
    let(:user) { create(:user, date_of_birth: 30.year.ago - 1.month) }

    before do
      allow(Time).to receive(:current).and_return(Time.current)
    end

    it "grants reward if within 60 days and spent > threshold" do
      create(:transaction, :default_country, user: user, amount: 1100, created_at: 12.days.ago, status: :processed)

      expect {
        described_class.call(user)
      }.to change { user.rewards.count }.by(1)

      expect(user.rewards.pluck(:message)).to include("new_user_spend")
    end

    it "does not grant reward if spend below threshold" do
    create(:transaction, :default_country, user: user, amount: 500, created_at: 20.days.ago, status: :processed)

    expect {
      described_class.call(user)
    }.not_to change { user.rewards.count }
    end

    it "does not grant reward if already received" do
    create(:transaction, :default_country, user: user, amount: 2000, created_at: 20.days.ago, status: :processed)
    create(:reward, user: user, reward_type: "free_movie_tickets", message: "new_user_spend")

    expect {
      described_class.call(user)
    }.not_to change { user.rewards.count }
    end
  end
end
