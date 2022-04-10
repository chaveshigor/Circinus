# frozen_string_literal: true

class CreateMatches < ActiveRecord::Migration[6.1]
  def change
    create_table :matches do |t|
      t.references :user_1, foreign_key: { to_table: :users }
      t.references :user_2, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
