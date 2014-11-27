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

  def thumbnail
    # find wallpaper by id
    wallpaper = Wallpaper.find(params[:id])
    if wallpaper
      # check width
      width = params[:width].to_i
      height = params[:height].to_i
      if Wallpaper.check_thumbnail_resolution(width, height)
        send_file wallpaper.crop_and_resize(width, height), type: wallpaper.mime_type, disposition: 'inline'
      else
        logger.warn "illegal thumbnail resolution #{width}x#{height}"
        render status: 400
      end
    else
      # send 404
      render status: 404
    end
  end
end
