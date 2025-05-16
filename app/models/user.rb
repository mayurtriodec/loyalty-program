# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :transactions, dependent: :destroy
  has_many :rewards, dependent: :destroy

  validates :date_of_birth, presence: true
  validates :country, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false },
    format: {
      with: URI::MailTo::EMAIL_REGEXP,
      message: "must be a valid email address"
    }

  before_validation :normalize_email
  before_create :regenerate_jti

  def regenerate_jti
    self.jti = SecureRandom.uuid
  end

  def invalidate_jti
    update(jti: SecureRandom.uuid)
  end

  def valid_jti?(token_jti)
    jti == token_jti
  end

  def normalize_email
    self.email = email.downcase.strip
  end

  def monthly_transaction_points
    domestic_amount = transactions.processed.domestic.created_in_month.sum(:amount)
    international_amount = transactions.processed.international.created_in_month.sum(:amount)
    total_points = domestic_amount * Reward::LOCAL_MULTIPLIER + international_amount * Reward::INTERNATIONAL_MULTIPLIER

    ((total_points) * Reward::BASE_MULTIPLIER).round(2)
  end

  def first_transaction_date
    transactions.processed.order(:created_at).pick(:created_at)&.to_date
  end
end
