# frozen_string_literal: true

class CreateProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :profiles do |t|
      t.string :first_name
      t.string :last_name
      t.datetime :born
      t.text :description
      t.string :city
      t.user :belongs_to

      t.timestamps
    end
  end
end
