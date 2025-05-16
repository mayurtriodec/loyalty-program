# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reward, type: :model do
  let(:user) { create(:user) }
  let(:reward) { create(:reward, user: user) }

  describe "associations" do
    it "belongs to a user" do
      expect(reward.user).to eq(user)
    end
  end

  describe "enums" do
    it "defines reward_type enum with prefix" do
      reward = build(:reward, reward_type: :free_coffee)
      expect(reward.reward_type).to eq("free_coffee")
      expect(Reward.reward_types.keys).to include("free_coffee", "free_movie_tickets")
      expect(reward).to respond_to(:reward_type_free_coffee?)
    end
  end
end
