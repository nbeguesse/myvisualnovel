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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130609030019) do

  create_table "characters", :force => true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.string   "type"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "sex",        :limit => 1, :default => "M"
  end

  add_index "characters", ["project_id"], :name => "index_characters_on_project_id"
  add_index "characters", ["type", "project_id"], :name => "index_characters_on_type_and_project_id"

  create_table "events", :force => true do |t|
    t.integer  "scene_id"
    t.integer  "order_index"
    t.integer  "character_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "type"
    t.string   "filename"
    t.string   "character_type"
    t.string   "subfilename"
    t.string   "text"
    t.text     "characters_present"
    t.string   "character_name"
  end

  add_index "events", ["scene_id"], :name => "index_events_on_scene_id"

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.boolean  "public",     :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "basename"
    t.string   "owner_id"
    t.string   "owner_type"
    t.integer  "views",      :default => 0
    t.string   "author"
  end

  create_table "scenes", :force => true do |t|
    t.integer  "project_id"
    t.integer  "order_index"
    t.string   "custom_description"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.boolean  "love_scene"
  end

  add_index "scenes", ["project_id"], :name => "index_scenes_on_project_id"

  create_table "users", :force => true do |t|
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email"

end
