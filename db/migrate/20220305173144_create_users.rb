# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.boolean :account_confirmed
      t.string :confirmation_token

      t.timestamps
    end
  end
end
