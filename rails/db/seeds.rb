# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Wallpaper.delete_all()

Dir.entries('app/assets/images').select{|f| f.end_with?('.jpg')}.each do |img|
  Wallpaper.create({
    title: File.basename(img, '.jpg'),
    width: 220,
    height: 125,
    storage_key: img
  })
end