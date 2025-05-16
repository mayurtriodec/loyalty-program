# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Api::V1::Transactions", type: :request do
  let(:user) { create(:user) }
  let(:headers) { auth_headers_for(user) }

  describe "POST /api/v1/transactions" do
    let(:valid_params) do
      {
        transaction: {
          amount: 150.75,
          country: "US"
        }
      }
    end

    let(:invalid_params) do
      {
        transaction: {
          amount: nil,
          country: ""
        }
      }
    end

    context "when request is valid" do
      it "creates the transaction and processes loyalty points" do
        post "/api/v1/transactions", params: valid_params, headers: headers

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)

        expect(json_response["data"]["amount"]).to eq("150.75")
      end
    end

    context "when request is invalid" do
      it "returns an error response" do
        post "/api/v1/transactions", params: invalid_params, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)

        expect(json_response["message"]).to eq("Validation failed: Amount can't be blank, Amount is not a number, Country can't be blank")
      end
    end

    context "when something unexpected fails" do
      before do
        allow_any_instance_of(Transaction).to receive(:save!).and_raise(StandardError, "Unexpected failure")
      end

      it "rescues and renders error message" do
        post "/api/v1/transactions", params: valid_params, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)

        expect(json_response["message"]).to eq("Unexpected failure")
      end
    end
  end
end
