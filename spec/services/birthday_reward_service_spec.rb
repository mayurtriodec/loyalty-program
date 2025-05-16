# frozen_string_literal: true

require "rails_helper"

RSpec.describe Rewards::BirthdayRewardService, type: :service do
  describe "birthday reward service call" do
    let(:user) { create(:user, date_of_birth: 30.year.ago - 1.month) }

    before do
      allow(Time).to receive(:current).and_return(Time.current)
    end

    it "grants reward if birthday month matches and not already issued" do
      user.update!(date_of_birth: Time.current - 25.years)
      expect {
        described_class.call(user)
      }.to change { user.rewards.count }.by(1)

      expect(user.rewards.last.message).to eq("birthday")
    end

    it "does not grant if already issued this month" do
      user.update!(date_of_birth: Time.current - 25.years)
      create(:reward, user: user, reward_type: "free_coffee", message: "birthday", issued_on: Time.current.to_date)

      expect {
        described_class.call(user)
      }.not_to change { user.rewards.count }
    end

    it "does not grant if birthday month doesn't match" do
      user.update!(date_of_birth: Time.current - 25.years - 1.month)

      expect {
        described_class.call(user)
      }.not_to change { user.rewards.count }
    end
  end
end
