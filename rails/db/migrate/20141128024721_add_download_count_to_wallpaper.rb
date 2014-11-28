class AddDownloadCountToWallpaper < ActiveRecord::Migration
  def change
    add_column :wallpapers, :download_count, :integer, default: 0
  end
end
