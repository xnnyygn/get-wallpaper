class CreateWallpapers < ActiveRecord::Migration
  def change
    create_table :wallpapers do |t|
      t.string :title, limit: 255
      t.integer :width
      t.integer :height
      t.string :storage_key, limit: 255

      t.timestamps
    end
  end
end
