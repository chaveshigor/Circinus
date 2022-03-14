class CreateProfileHobbies < ActiveRecord::Migration[6.1]
  def change
    create_table :profile_hobbies do |t|
      t.references :profiles, null: false, foreign_key: true
      t.references :hobbies, null: false, foreign_key: true

      t.timestamps
    end
  end
end
