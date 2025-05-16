# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:user) { create(:user) }
  let(:transaction) { create(:transaction, :default_country, user: user) }

  describe "associations" do
    it "belongs to a user" do
      expect(transaction.user).to eq(user)
    end
  end

  describe "validations" do
    it "is invalid without amount" do
      transaction_without_amount = build(:transaction, :default_country, amount: nil)
      expect(transaction_without_amount).not_to be_valid
      expect(transaction_without_amount.errors[:amount]).to include("can't be blank")
    end

    it "is invalid without country" do
      transaction_without_country = build(:transaction, country: nil)
      expect(transaction_without_country).not_to be_valid
      expect(transaction_without_country.errors[:country]).to include("can't be blank")
    end
  end

  describe "aasm states" do
    let(:transaction) { create(:transaction, :default_country, status: :pending) }

    it "initializes with pending state" do
      expect(transaction).to be_pending
    end

    it "transitions from pending to processed" do
      transaction.process!
      expect(transaction).to be_processed
    end

    it "transitions from pending to failed" do
      transaction.fail!
      expect(transaction).to be_failed
    end
  end
end
