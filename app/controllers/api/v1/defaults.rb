# frozen_string_literal: true

module Api
  module V1
    module Defaults
      extend ActiveSupport::Concern

      included do
        prefix "api"
        version "v1", using: :path
        default_format :json
        format :json

        helpers do
          def declared_params
            @declared_params ||= declared(params)
          end
        end

        rescue_from ActiveRecord::RecordNotFound do |e|
          error!({ code: 404, message: e.message }, 404)
        end

        rescue_from ActiveRecord::RecordInvalid do |e|
          error!({ code: 422, message: e.message }, 422)
        end

        rescue_from StandardError do |e|
          error!({ code: 422, message: e.message }, 422)
        end
      end
    end
  end
end
