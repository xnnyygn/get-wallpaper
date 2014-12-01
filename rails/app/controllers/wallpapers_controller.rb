class WallpapersController < ApplicationController

  skip_before_action :authorize, except: [:new, :create, :add_to_collection]

  def index
    if @current_user
      # TODO implement recommend
      @wallpapers_recommend = Wallpaper.all().limit(5)
    end
    @wallpapers_latest = Wallpaper.order(updated_at: :desc).limit(5)
    @wallpapers_popular = Wallpaper.order(download_count: :desc).limit(5)
  end

  def list_recommend
    # TODO ITEM CF
    @wallpaper = Wallpaper.all()
  end

  def list_latest
    @wallpapers = Wallpaper.order(updated_at: :desc).page(params[:page]).per(20)
  end

  def list_popular
    @wallpapers = Wallpaper.order(download_count: :desc).page(params[:page]).per(20)
  end

  def list_category
    @category = Category.find(params[:category_id])
    @wallpapers = Wallpaper.where(category: @category).order(updated_at: :desc).page(params[:page]).per(20)
  end

  def filter
    tag_text = params[:tag]
    if tag_text.blank?
      redirect_to latest_wallpapers_url
    else
      @tag = Tag.find_by(name: params[:tag])
      if @tag
        @wallpapers = @tag.wallpapers.page(params[:page]).per(20)
      end
    end
  end

  def thumbnail
    # find wallpaper by id
    # TODO handle ActiveRecord::NotFound
    wallpaper = Wallpaper.find(params[:id])
    if wallpaper
      # check width
      width = params[:width].to_i
      height = params[:height].to_i
      if Wallpaper.check_thumbnail_resolution(width, height)
        send_file wallpaper.crop_and_resize(width, height), type: wallpaper.mime_type, disposition: 'inline'
      else
        logger.warn "illegal thumbnail resolution #{width}x#{height}"
        # TODO return message
        render status: 400
      end
    else
      # send 404
      render status: 404
    end
  end

  def download_dialog
    @wallpaper = Wallpaper.find(params[:id])
    if @current_user
      @wallpaper_stat = WallpaperStat.find_by(wallpaper: @wallpaper, user: @current_user) || WallpaperStat.new
    end
    render layout:false
  end

  def add_to_collection
    wallpaper = Wallpaper.find(params[:id])
    wallpaper_stat = WallpaperStat.find_or_create(wallpaper, @current_user)
    wallpaper_stat.favorite = true
    wallpaper_stat.save

    respond_to do |format|
      format.js
    end
  end

  def remove_from_collection
    wallpaper = Wallpaper.find(params[:id])
    wallpaper_stat = WallpaperStat.find_or_create(wallpaper, @current_user)
    wallpaper_stat.favorite = false
    wallpaper_stat.save
    
    respond_to do |format|
      format.js
    end
  end

  def download
    ActiveRecord::Base.transaction do
      wallpaper = Wallpaper.find(params[:id])
      if wallpaper
        # check width
        width = params[:width].to_i
        height = params[:height].to_i
        if wallpaper.check_resolution(width, height)
          # increase download count
          wallpaper.download_count += 1
          wallpaper.save()

          # merge wallpaper stat
          wallpaper_stat = WallpaperStat.find_or_create(wallpaper, @current_user)
          wallpaper_stat.download_count += 1
          wallpaper_stat.save()

          send_file wallpaper.crop_and_resize(width, height), 
            filename: "#{wallpaper.title}-#{width}x#{height}#{wallpaper.determine_extension}",
            type: wallpaper.mime_type,
            disposition:'attachment'
        else
          logger.warn "illegal resolution #{width}x#{height}"
          # TODO return message
          render status: 400
        end
      else
        # send 404
        render status: 404
      end
    end
  end

  def show
    @wallpaper = Wallpaper.find(params[:id])
  end

  def new
    @wallpaper = Wallpaper.new()
  end

  def create
    @wallpaper = Wallpaper.new({
      title: params[:title], 
      category: Category.find(params[:category_id]),
      uploader: @current_user
    })
    # validate wallpaper
    if @wallpaper.valid? && check_and_save_wallpaper(@wallpaper, params[:wallpaper])

      tags = Tag.ensure_all(params[:tags])
      @wallpaper.tags = tags
      @wallpaper.save()

      redirect_to latest_wallpapers_url
    else
      render :new
    end
  end

  private
    def check_and_save_wallpaper(wallpaper, wallpaper_tmpfile)
      # check if empty
      if wallpaper_tmpfile.nil?
        @wallpaper.errors[:base] = 'image required'
        return false
      end

      # check size 1M threshold
      logger.debug "wallpaper size #{wallpaper_tmpfile.size}"
      if wallpaper_tmpfile.size > 1024 * 1024
        @wallpaper.errors[:base] = 'image too large, size threshold 1M'
        return false
      end

      # retrieve resolution
      identify_result = `identify -format '%w %h' #{wallpaper_tmpfile.path}`
      if $?.to_i != 0
        @wallpaper.errors[:base] = 'failed to retrieve resolution from image'
        return false
      end

      resolution = identify_result.split
      width = resolution[0].to_i
      height = resolution[1].to_i
      logger.debug "wallpaper resolution #{width}x#{height}"
      storage_key = SecureRandom.uuid()

      # check resolution
      unless Wallpaper.check_minimum_resolution(width, height)
        @wallpaper.errors[:base] = 'the minimum resolution of wallpaper is 800x600'
        return false
      end
      
      dest_path = Wallpaper.determine_storage_path(storage_key)
      logger.info "upload wallpaper to #{dest_path}"
      File.open(dest_path, 'wb') {
        |df| df.write(wallpaper_tmpfile.read)
      }

      @wallpaper.storage_key = storage_key
      @wallpaper.width = width
      @wallpaper.height = height
      @wallpaper.mime_type = wallpaper_tmpfile.content_type
      return true
    end


end
