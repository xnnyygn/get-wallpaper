class AddUploaderToWallpaper < ActiveRecord::Migration
  def change
    add_reference :wallpapers, :uploader, index: true
  end
end
