class CreateProfileHobbies < ActiveRecord::Migration[6.1]
  def change
    create_table :profile_hobbies do |t|
      t.references :profile, null: false, foreign_key: true
      t.references :hobby, null: false, foreign_key: true

      t.timestamps
    end
  end
end
