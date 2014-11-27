class Wallpaper < ActiveRecord::Base

  def self.check_thumbnail_resolution(width, height)
    VALID_THUMBNAIL_RESOLUTION.include? [width, height]
  end

  def self.check_extension(extension)
    EXTENSION_MIME_TYPE_MAPPING.include? extension
  end

  def self.get_mime_type_by_extension(extension)
    EXTENSION_MIME_TYPE_MAPPING[extension]
  end

  def self.check_resolution(width, height)
    width >= MIN_WIDTH && height >= MIN_HEIGHT
  end

  def crop_and_resize(target_width, target_height)
    # #{id}-#{width}
    target_file_name = "#{storage_key}-#{target_width}x#{target_height}"
    target_file_path = File.join(STORAGE_TARGET_FOLDER, target_file_name)
    unless File.exists?(target_file_path)
      original_file_name = "#{storage_key}"
      original_file_path = File.join(STORAGE_ORIGINAL_FOLDER, original_file_name)

      source_width = width
      source_height = height
      source_ratio = width * 1.0 / height
      target_ratio = target_width * 1.0 / target_height
      crop_bound = calculate_crop_bound(source_width, source_height, source_ratio, target_ratio)
      # generate by ImageMagick
      command = "convert #{original_file_path} -crop #{crop_bound[0]}x#{crop_bound[1]}+#{crop_bound[2]}+#{crop_bound[3]} -resize #{target_width}x#{target_height} #{target_file_path}"
      logger.info command
      `#{command}`
    end
    target_file_path
  end

  private
    VALID_THUMBNAIL_RESOLUTION = Set.new([
      [200, 125],
      [800, 600]
    ])
    STORAGE_ROOT = File.join(Rails.public_path, 'images', 'wallpapers')
    STORAGE_ORIGINAL_FOLDER = File.join(STORAGE_ROOT, 'original')
    STORAGE_TARGET_FOLDER = File.join(STORAGE_ROOT, 'target')
    EXTENSION_MIME_TYPE_MAPPING = {
      '.jpg' => 'image/jpeg',
      '.jpeg' => 'image/jpeg'
    }
    MIN_WIDTH = 800
    MIN_HEIGHT = 600

    def calculate_crop_bound(source_width, source_height, source_ratio, target_ratio)
      if source_ratio >= target_ratio
        crop_width = source_height * target_ratio
        [
          crop_width.to_i,
          source_height,
          ((source_width - crop_width) / 2).to_i,
          0
        ]
      else
        crop_height = source_height / target_ratio
        [
          source_width,
          crop_height.to_i,
          0,
          ((source_height - crop_height) / 2).to_i
        ]
      end
    end

end