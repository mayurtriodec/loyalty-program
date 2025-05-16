# frozen_string_literal: true

class Reward < ApplicationRecord
  belongs_to :user, inverse_of: :rewards

  validates :reward_type, presence: true
  validates :issued_on, presence: true
end
