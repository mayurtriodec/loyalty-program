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

end
