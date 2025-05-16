# frozen_string_literal: true

module Api
  module V1
    class Auth < Grape::API
      include Api::V1::Defaults
      helpers AuthenticateHelpers

      resource :auth do
        desc "Register a new user"
        params do
          requires :email, type: String, desc: "User email address", regexp: URI::MailTo::EMAIL_REGEXP
          requires :password, type: String, desc: "Password (minimum 8 characters)", length: { minimum: 8 }
          requires :date_of_birth, type: Date, desc: "Date of birth (YYYY-MM-DD)"
          requires :country, type: String, desc: "Country name"
        end
        post "/register" do
          user = User.create!(declared(params))

          { token: generate_token(user), data:  UserSerializer.new(user).serializable_hash[:data][:attributes] }
        end

        desc "Login a user"
        params do
          requires :email, type: String, desc: "User email address", regexp: URI::MailTo::EMAIL_REGEXP
          requires :password, type: String, desc: "Password (minimum 8 characters)", length: { minimum: 8 }
        end
        post "/login" do
          user_params = declared(params, include_missing: false).compact
          user = User.find_by(email: user_params[:email])

          if user&.authenticate(user_params[:password])
            { token: generate_token(user), data:  UserSerializer.new(user).serializable_hash[:data][:attributes] }
          else
            error!("Invalid credentials", 401)
          end
        end

        desc "Logout a user"
        delete "/logout" do
          authenticate_user!

          current_user.invalidate_jti

          { message: "Successfully logged out" }
        end
      end
    end
  end
end
