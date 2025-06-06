# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email,  null: false
      t.string :password_digest

      t.timestamps null: false
    end

    add_index :users, :email,  unique: true
  end
end
