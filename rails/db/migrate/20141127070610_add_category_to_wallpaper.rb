class AddCategoryToWallpaper < ActiveRecord::Migration
  def change
    add_reference :wallpapers, :category, index: true
  end
end
