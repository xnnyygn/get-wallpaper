class CreateWallpaperStats < ActiveRecord::Migration
  def change
    create_table :wallpaper_stats do |t|
      t.references :user, index: true
      t.references :wallpaper, index: true
      t.integer :rate, default: 0
      t.integer :download_count, default: 0
      t.boolean :favorite, default: false

      t.timestamps
    end
  end
end
