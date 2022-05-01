class CreatePictures < ActiveRecord::Migration[6.1]
  def change
    create_table :pictures do |t|
      t.string :storage_service_key
      t.integer :position
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
