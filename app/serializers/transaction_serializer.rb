# frozen_string_literal: true

class TransactionSerializer
  include JSONAPI::Serializer
  attributes :id, :amount, :country, :status, :created_at

  attribute :loyalty_points do |transaction|
    transaction.user.loyalty_points.to_f.round(2)
  end
end
