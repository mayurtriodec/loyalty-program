# frozen_string_literal: true

class UserSerializer
  include JSONAPI::Serializer

  attributes :id, :email, :country, :date_of_birth, :created_at, :updated_at
end
