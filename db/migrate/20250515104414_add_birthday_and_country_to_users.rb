# frozen_string_literal: true

class AddBirthdayAndCountryToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :date_of_birth, :date
    add_column :users, :country, :string
    add_column :users, :loyalty_points, :decimal, precision: 10, scale: 2, default: 0.0, null: false
  end
end
