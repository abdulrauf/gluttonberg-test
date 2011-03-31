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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101111002552) do

  create_table "gb_asset_categories", :force => true do |t|
    t.string  "name",    :null => false
    t.boolean "unknown"
  end

  create_table "gb_asset_collections", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
  end

  create_table "gb_asset_collections_assets", :id => false, :force => true do |t|
    t.integer "asset_collection_id", :null => false
    t.integer "asset_id",            :null => false
  end

  create_table "gb_asset_mime_types", :force => true do |t|
    t.string  "mime_type",                    :null => false
    t.integer "asset_type_id", :default => 0
  end

  create_table "gb_asset_types", :force => true do |t|
    t.string  "name",                             :null => false
    t.integer "asset_category_id", :default => 0
  end

  create_table "gb_assets", :force => true do |t|
    t.string   "mime_type"
    t.integer  "asset_type_id"
    t.string   "name",               :null => false
    t.text     "description"
    t.string   "file_name"
    t.string   "asset_hash"
    t.integer  "size"
    t.boolean  "custom_thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "synopsis"
    t.text     "copyrights"
    t.integer  "year_of_production"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.string   "duration"
  end

  create_table "gb_audio_asset_attributes", :force => true do |t|
    t.integer  "asset_id",   :null => false
    t.float    "length"
    t.string   "title"
    t.string   "artist"
    t.string   "album"
    t.string   "tracknum"
    t.string   "genre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gb_dialects", :force => true do |t|
    t.string  "code",    :limit => 15,                    :null => false
    t.string  "name",    :limit => 70,                    :null => false
    t.boolean "default",               :default => false
    t.integer "user_id"
  end

  create_table "gb_dialects_locales", :id => false, :force => true do |t|
    t.integer "locale_id",  :null => false
    t.integer "dialect_id", :null => false
  end

  create_table "gb_html_content_localizations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "text"
    t.integer  "html_content_id"
    t.integer  "page_localization_id"
  end

  create_table "gb_html_contents", :force => true do |t|
    t.boolean  "orphaned",                   :default => false
    t.string   "section_name", :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "page_id"
  end

  create_table "gb_image_contents", :force => true do |t|
    t.boolean  "orphaned",                   :default => false
    t.string   "section_name", :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "asset_id"
    t.integer  "page_id"
  end

  create_table "gb_locales", :force => true do |t|
    t.string  "name",      :limit => 70,                    :null => false
    t.string  "slug",      :limit => 70,                    :null => false
    t.boolean "default",                 :default => false
    t.integer "locale_id"
    t.integer "user_id"
  end

  create_table "gb_page_localizations", :force => true do |t|
    t.string   "name",             :limit => 150
    t.string   "navigation_label", :limit => 100
    t.string   "slug",             :limit => 50
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "dialect_id"
    t.integer  "locale_id"
    t.integer  "page_id"
  end

  create_table "gb_pages", :force => true do |t|
    t.integer  "parent_id"
    t.string   "name",             :limit => 100
    t.string   "navigation_label", :limit => 100
    t.string   "slug",             :limit => 100
    t.string   "description_name", :limit => 100
    t.boolean  "home",                            :default => false
    t.integer  "depth",                           :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.integer  "user_id"
  end

  create_table "gb_plain_text_content_localizations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "page_localization_id"
    t.string   "text"
    t.integer  "plain_text_content_id"
  end

  create_table "gb_plain_text_contents", :force => true do |t|
    t.boolean  "orphaned",                   :default => false
    t.string   "section_name", :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "page_id"
  end

  create_table "gb_settings", :force => true do |t|
    t.string  "name",        :limit => 50,                   :null => false
    t.text    "value"
    t.integer "category",                  :default => 1
    t.integer "row"
    t.boolean "delete_able",               :default => true
    t.boolean "enabled",                   :default => true
    t.text    "help"
  end

  create_table "gb_users", :force => true do |t|
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
