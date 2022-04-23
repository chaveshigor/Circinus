class AddPictureS3ToPictures < ActiveRecord::Migration[6.1]
  def change
    add_column :pictures, :picture_s3, :string
  end
end
