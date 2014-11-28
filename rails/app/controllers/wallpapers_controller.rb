class WallpapersController < ApplicationController
  def index
    # TODO remove true
    if true or @current_user
      @wallpapers_recommend = Wallpaper.all().limit(5)
    end
    @wallpapers_latest = Wallpaper.order(updated_at: :desc).limit(5)
    @wallpapers_popular = Wallpaper.order(download_count: :desc).limit(5)
  end

  def list
    render text: 'Wallpaper List'
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
    render layout:false
  end

  def download
    wallpaper = Wallpaper.find(params[:id])
    if wallpaper
      # check width
      width = params[:width].to_i
      height = params[:height].to_i
      if wallpaper.check_resolution(width, height)
        # increase download count
        wallpaper.download_count += 1
        wallpaper.save()

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

  def new
    @wallpaper = Wallpaper.new()
  end

  def create
    # validate wallpaper
    @wallpaper = Wallpaper.new({
      title: params[:title], 
      category: Category.find(params[:category_id])
    })
    if @wallpaper.valid?
      file = params[:wallpaper]
      if file
        # check resolution
        identify_result = `identify -format '%w %h' #{file.path}`
        if $?.to_i == 0
          resolution = identify_result.split
          width = resolution[0].to_i
          height = resolution[1].to_i
          logger.debug "wallpaper resolution #{width}x#{height}"
          storage_key = SecureRandom.uuid()

          if Wallpaper.check_minimum_resolution(width, height)
            dest_path = Wallpaper.determine_storage_path(storage_key)
            logger.info "upload wallpaper to #{dest_path}"
            File.open(dest_path, 'wb') {
              |df| df.write(file.read)
            }

            @wallpaper.storage_key = storage_key
            @wallpaper.width = width
            @wallpaper.height = height
            @wallpaper.mime_type = file.content_type
            @wallpaper.save()
            redirect_to latest_wallpapers_url
            return
          else
            @wallpaper.errors[:base] = 'the minimum resolution of wallpaper is 800x600'
          end
        else
          @wallpaper.errors[:base] = 'failed to retrieve resolution from image'
        end
      else
        @wallpaper.errors[:base] = 'image required'
      end
    end
    render :new
  end

end
