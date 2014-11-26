class WallpapersController < ApplicationController
  def index
    # TODO remove true
    if true or @current_user
      @wallpapers_recommend = Wallpaper.all().limit(5)
    end
    @wallpapers_latest = Wallpaper.all().limit(5)
    @wallpapers_popular = @wallpapers_latest
  end

  def list
    render text: 'Wallpaper List'
  end

  def list_recommend
    # TODO ITEM CF
    @wallpaper = Wallpaper.all()
  end

  def list_latest
    # TODO add paginate
    @wallpapers = Wallpaper.order(created_at: :desc).page(params[:page]).per(20)
  end

  def list_popular
    # TODO sort by download count
    @wallpapers = Wallpaper.all()
  end
end
