# frozen_string_literal: true

class CreateRewards < ActiveRecord::Migration[8.0]
  def change
    create_table :rewards do |t|
      t.references :user, null: false, foreign_key: true
      t.string :reward_type
      t.string :message, comment: "Reason for reward issuance"
      t.date :issued_on

      t.timestamps
    end
  end
end
