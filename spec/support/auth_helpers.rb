# frozen_string_literal: true

module AuthHelpers
  def auth_headers_for(user)
    token = Auth::JwtService.encode(user)
    { "Authorization" => "Bearer #{token}" }
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :request
end
