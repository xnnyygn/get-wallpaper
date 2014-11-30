class Tag < ActiveRecord::Base
  has_many :wallpaper_tags
  has_many :wallpapers, :through => :wallpaper_tags

  def self.ensure_all(tag_names)
    tags = []
    tag_names.split.each do |name|
      tag = Tag.find_by(name: name)
      if tag.nil?
        tag = Tag.create({name: name})
      end
      tags << tag
    end
    tags
  end

end
