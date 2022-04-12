# frozen_string_literal: true

class CreateMatches < ActiveRecord::Migration[6.1]
  def change
    create_table :matches do |t|
      t.references :profile_1, foreign_key: { to_table: :profiles }
      t.references :profile_2, foreign_key: { to_table: :profiles }
      t.timestamps
    end
  end
end
