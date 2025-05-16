# frozen_string_literal: true

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:valid_user) { build(:user) }

  describe "associations" do
    describe "transactions" do
      let!(:transaction) { create(:transaction, :default_country, user: user) }

      it "has many transactions" do
        expect(user.transactions).to include(transaction)
      end

      it "destroys transactions with user" do
        expect { user.destroy }
          .to change { Transaction.exists?(transaction.id) }
          .from(true).to(false)
      end
    end

    describe "rewards" do
      let!(:reward) { create(:reward, user: user) }

      it "has many rewards" do
        expect(user.rewards).to include(reward)
      end

      it "destroys rewards with user" do
        expect { user.destroy }
          .to change { Reward.exists?(reward.id) }
          .from(true).to(false)
      end
    end
  end

  describe "validations" do
    context "without date_of_birth" do
      let(:invalid_user) { build(:user, date_of_birth: nil) }

      it "is invalid" do
        expect(invalid_user).not_to be_valid
        expect(invalid_user.errors[:date_of_birth]).to include("can't be blank")
      end
    end

    context "without country" do
      let(:invalid_user) { build(:user, country: nil) }

      it "is invalid" do
        expect(invalid_user).not_to be_valid
        expect(invalid_user.errors[:country]).to include("can't be blank")
      end
    end
  end

  describe "creation" do
    context "with valid attributes" do
      it "is valid" do
        expect(valid_user).to be_valid
      end

      it "generates jti token" do
        valid_user.save!
        expect(valid_user.jti).to be_present
      end
    end
  end
end
