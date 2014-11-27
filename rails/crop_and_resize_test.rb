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

source_width = 1440
source_height = 900
source_file_path = '/Users/xnnyygn/Pictures/wallpapers2/a_little_house_in_hangzhou-wallpaper-1440x900.jpg'

target_width = 800
target_height = 600

source_ratio = source_width * 1.0 / source_height
target_ratio = target_width * 1.0 / target_height

crop_bound = calculate_crop_bound(source_width, source_height, source_ratio, target_ratio)
puts crop_bound

cmd = "convert #{source_file_path} -crop #{crop_bound[0]}x#{crop_bound[1]}+#{crop_bound[2]}+#{crop_bound[3]} -resize #{target_width}x#{target_height} foo.jpg"
puts cmd
`#{cmd}`