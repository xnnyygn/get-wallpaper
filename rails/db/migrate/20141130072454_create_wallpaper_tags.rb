class CreateWallpaperTags < ActiveRecord::Migration
  def change
    create_table :wallpaper_tags do |t|
      t.references :wallpaper, index: true
      t.references :tag, index: true
      t.timestamps
    end
  end
end
