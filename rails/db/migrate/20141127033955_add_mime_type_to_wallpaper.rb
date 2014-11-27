class AddMimeTypeToWallpaper < ActiveRecord::Migration
  def change
    add_column :wallpapers, :mime_type, :string, limit: 32
  end
end
