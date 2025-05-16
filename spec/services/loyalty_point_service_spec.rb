# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Loyalty::PointsService, type: :service do
  describe "process_transaction" do
    let(:user) { create(:user, country: "US", loyalty_points: 0.0) }

    context "when transaction is not processed" do
      let(:transaction) { create(:transaction, user: user, amount: 100, country: "US", status: :pending) }

      it "does not award any points or call RewardService" do
        expect {
          Loyalty::PointsService.new(transaction).process
        }.not_to change { user.reload.loyalty_points }
      end
    end

    context "when transaction is processed and country is home country" do
      let(:transaction) { create(:transaction, user: user, amount: 100, country: "US", status: :processed) }

      it "awards 10% of amount as loyalty points" do
        expect {
          Loyalty::PointsService.new(transaction).process
        }.to change { user.reload.loyalty_points }.by(10.0)
      end
    end

    context "when transaction is processed and country is different from home country" do
      let(:transaction) { create(:transaction, user: user, amount: 100, country: "USA", status: :processed) }

      it "awards double loyalty points" do
        expect {
          Loyalty::PointsService.new(transaction).process
        }.to change { user.reload.loyalty_points }.by(20.0)
      end
    end
  end
end
