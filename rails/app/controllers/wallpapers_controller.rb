class WallpapersController < ApplicationController
  def index
    @image_files = Dir.entries('app/assets/images').select{|n| n.end_with?('.jpg')}
    logger.debug('IMAGE FILES ' + @image_files.to_s)
  end

  def list
  end
end
