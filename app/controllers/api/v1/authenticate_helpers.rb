# frozen_string_literal: true

module Api
  module V1
    module AuthenticateHelpers
      def current_user
        return @current_user if defined?(@current_user)
        return unless decoded_token

        @current_user = User.find_by(id: @decoded_token[:sub])
        return unless @current_user&.valid_jti?(@decoded_token[:jti])

        @current_user
      end

      def authenticate_user!
        error!({ error: "Unauthorized" }, 401) unless current_user
      rescue JWT::DecodeError, JWT::ExpiredSignature => e
        error!({ error: "Invalid token: #{e.message}" }, 401)
      end

      def generate_token(user)
        ::Auth::JwtService.encode(user)
      end

      def decoded_token
        @decoded_token ||= begin
          header = headers["Authorization"]
          return unless header

          token = header.split(" ").last
          ::Auth::JwtService.decode(token)
        end
      end
    end
  end
end
