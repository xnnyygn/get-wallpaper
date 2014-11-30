class WallpaperTag < ActiveRecord::Base
  belongs_to :tag
  belongs_to :wallpaper
end
