# frozen_string_literal: true

module Auth
  class JwtService
    SECRET_KEY = Rails.application.credentials.secret_key_base
    EXPIRATION = 24.hours

    def self.encode(user)
      payload = {
        sub: user.id,
        jti: user.jti,
        exp: EXPIRATION.from_now.to_i
      }

      JWT.encode(payload, SECRET_KEY)
    end

    def self.decode(token)
      decoded = JWT.decode(token, SECRET_KEY)[0]
      HashWithIndifferentAccess.new(decoded)
    rescue
      nil
    end
  end
end
