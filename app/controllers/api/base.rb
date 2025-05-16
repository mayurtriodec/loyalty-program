# frozen_string_literal: true

module Api
  class Base < Grape::API
    mount Api::V1::Base
  end
end
