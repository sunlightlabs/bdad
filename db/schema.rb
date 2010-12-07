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

ActiveRecord::Schema.define(:version => 5) do

  create_table "awards", :id => false, :force => true do |t|
    t.string  "name",      :limit => nil
    t.integer "id"
    t.point   "the_point", :limit => nil
  end

  add_index "awards", ["id"], :name => "awards_id_key", :unique => true

  create_table "bgs", :primary_key => "gid", :force => true do |t|
    t.integer "__gid",      :limit => 8
    t.decimal "area"
    t.decimal "perimeter"
    t.string  "bg01_d00_",  :limit => 21
    t.string  "bg01_d00_i", :limit => 21
    t.string  "state"
    t.string  "county"
    t.string  "tract"
    t.string  "blkgroup"
    t.string  "name"
    t.string  "lsad"
    t.string  "lsad_trans"
    t.string  "the_geom"
    t.point   "the_point",  :limit => nil
    t.integer "pop"
    t.integer "state_i"
    t.integer "county_i"
    t.integer "tract_i"
    t.integer "blkgroup_i"
  end

  add_index "bgs", ["state", "county", "tract", "blkgroup"], :name => "blockgroup_compound_id"
  add_index "bgs", ["state_i", "county_i", "tract_i", "blkgroup_i"], :name => "ids_ints"
  add_index "bgs", ["the_point"], :name => "bg_new_id1", :spatial => true

  create_table "cd110", :primary_key => "gid", :force => true do |t|
    t.string        "state",      :limit => 2
    t.string        "cd",         :limit => 2
    t.string        "lsad",       :limit => 2
    t.string        "name",       :limit => 90
    t.string        "lsad_trans", :limit => 50
    t.multi_polygon "the_geom",   :limit => nil
  end

  create_table "districts", :force => true do |t|
    t.string   "state_name",    :limit => 30
    t.string   "district_code", :limit => 2
    t.string   "state_code",    :limit => 2
    t.string   "combined_code", :limit => 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.geometry "geometry",      :limit => nil
  end

  create_table "sketches", :force => true do |t|
    t.string   "title"
    t.string   "byline"
    t.integer  "district_id"
    t.string   "token",       :limit => 16
    t.text     "paths",                      :default => ""
    t.boolean  "reviewed",                   :default => false
    t.boolean  "appropriate",                :default => false
    t.boolean  "gallery",                    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.geometry "geometry",    :limit => nil
    t.boolean  "editable",                   :default => true
    t.integer  "quality"
    t.integer  "hilarity"
  end

  create_table "states", :primary_key => "gid", :force => true do |t|
    t.decimal       "area"
    t.decimal       "perimeter"
    t.integer       "st99_d00_",  :limit => 8
    t.integer       "st99_d00_i", :limit => 8
    t.string        "state",      :limit => 2
    t.string        "name",       :limit => 90
    t.string        "lsad",       :limit => 2
    t.string        "region",     :limit => 1
    t.string        "division",   :limit => 1
    t.string        "lsad_trans", :limit => 50
    t.multi_polygon "the_geom",   :limit => nil
  end

  create_table "unsaved_sketches", :force => true do |t|
    t.integer  "district_id"
    t.text     "paths",                      :default => ""
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.geometry "geometry",    :limit => nil
  end

end
