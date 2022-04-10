# frozen_string_literal: true

class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.references :user_sender, foreign_key: { to_table: :users }
      t.references :user_receiver, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
