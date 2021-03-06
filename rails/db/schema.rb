# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141130104727) do

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wallpaper_stats", force: true do |t|
    t.integer  "user_id"
    t.integer  "wallpaper_id"
    t.integer  "rate",           default: 0
    t.integer  "download_count", default: 0
    t.boolean  "favorite",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wallpaper_stats", ["user_id"], name: "index_wallpaper_stats_on_user_id"
  add_index "wallpaper_stats", ["wallpaper_id"], name: "index_wallpaper_stats_on_wallpaper_id"

  create_table "wallpaper_tags", force: true do |t|
    t.integer  "wallpaper_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wallpaper_tags", ["tag_id"], name: "index_wallpaper_tags_on_tag_id"
  add_index "wallpaper_tags", ["wallpaper_id"], name: "index_wallpaper_tags_on_wallpaper_id"

  create_table "wallpapers", force: true do |t|
    t.string   "title"
    t.integer  "width"
    t.integer  "height"
    t.string   "storage_key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mime_type",      limit: 32
    t.integer  "category_id"
    t.integer  "download_count",            default: 0
    t.integer  "uploader_id"
  end

  add_index "wallpapers", ["category_id"], name: "index_wallpapers_on_category_id"
  add_index "wallpapers", ["uploader_id"], name: "index_wallpapers_on_uploader_id"

end
