# frozen_string_literal: true

class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.references :profile_sender, foreign_key: { to_table: :profiles }
      t.references :profile_receiver, foreign_key: { to_table: :profiles }
      t.timestamps
    end
  end
end
