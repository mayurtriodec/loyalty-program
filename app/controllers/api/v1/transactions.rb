# frozen_string_literal: true

module Api
  module V1
    class Transactions < Grape::API
      include Api::V1::Defaults
      helpers AuthenticateHelpers

      resource :transactions do
        desc "Create a new transaction"
        params do
          requires :transaction, type: Hash do
            requires :amount, type: Float, desc: "Transaction amount"
            requires :country, type: String, desc: "Transaction country"
          end
        end
        post do
          authenticate_user!

          transaction = @current_user.transactions.new(declared(params)[:transaction])

          ActiveRecord::Base.transaction do
            transaction.save!
            transaction.process!

            service = Loyalty::PointsService.new(transaction)
            service.process
          end

          { data: TransactionSerializer.new(transaction).serializable_hash[:data][:attributes] }
        end
      end
    end
  end
end
