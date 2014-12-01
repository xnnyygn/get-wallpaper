class WallpaperStat < ActiveRecord::Base
  belongs_to :user
  belongs_to :wallpaper

  def self.find_or_create(wallpaper, user)
    wallpaper_stat = WallpaperStat.find_by(wallpaper: wallpaper, user: user)
    if wallpaper_stat.nil?
      wallpaper_stat = WallpaperStat.new({
        wallpaper: wallpaper,
        user: user,
        download_count: 0,
        rate: 0,
        favorite: false
      })
    end
    wallpaper_stat
  end
  
end