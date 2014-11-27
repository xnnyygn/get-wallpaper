# TODO list pictures under folder

# picture source = /Users/xnnyygn/Pictures/wallpapers2
# TODO iterate source directory
# TODO get width and height from picture
# TODO convert thumbnail 200x?
# TODO separate source file to wallpapers-storage-root-path/original, thumbnail

WALLPAPER_FOLDER = '/Users/xnnyygn/Pictures/wallpapers2'
WALLPAPER_NAME_PATTERN = /^([^-]*)-wallpaper-(\d+)x(\d+)/

STORAGE_ROOT_PATH = '/Users/xnnyygn/Projects/get-wallpaper/rails/public/images/wallpapers'
STORAGE_ORIGINAL_FOLDER_NAME = 'original'

Dir.entries(WALLPAPER_FOLDER).each do |f|
  ext = File.extname(f)
  unless Wallpaper.check_extension(ext)
    puts "not wallpaper, ext #{ext}"
    next
  end

  # example file name a_little_house_in_hangzhou-wallpaper-1440x900.jpg
  md = f.match(WALLPAPER_NAME_PATTERN)
  unless md
    puts "not match file name pattern"
    next
  end

  title = md[1]
  width = md[2].to_i
  height = md[3].to_i
  unless Wallpaper.check_resolution(width, height)
    puts "resolution too low, #{width}x#{height}"
    next
  end

  puts "process file, title: #{title}, width: #{width}, height: #{height}"
  # find wallpaper by name
  if Wallpaper.find_by(title: title)
    next
  end
  storage_key = SecureRandom.uuid()
  wallpaper_path = File.join(WALLPAPER_FOLDER, f)
  # copy original file to original folder
  FileUtils.copy(
    wallpaper_path,
    File.join(STORAGE_ROOT_PATH, STORAGE_ORIGINAL_FOLDER_NAME, storage_key)
  )

  Wallpaper.create({
    title: title,
    width: width,
    height: height,
    storage_key: storage_key,
    mime_type: Wallpaper.get_mime_type_by_extension(ext)
  })
end