# frozen_string_literal: true

class Transaction < ApplicationRecord
  include AASM

  belongs_to :user

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :country, presence: true

  scope :processed, -> { where(status: :processed) }
  scope :created_in_month, -> { where(created_at: Time.current.all_month) }
  scope :domestic, -> {
    joins(:user).where("transactions.country = users.country")
  }
  scope :international, -> {
    joins(:user).where("transactions.country <> users.country")
  }

  aasm column: :status do
    state :pending, initial: true
    state :processed
    state :failed

    event :process do
      transitions from: :pending, to: :processed
    end

    event :fail do
      transitions from: :pending, to: :failed
    end
  end
end
