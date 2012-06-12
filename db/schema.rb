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

ActiveRecord::Schema.define(:version => 20120608024235) do

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         :default => 0
    t.string   "comment"
    t.string   "remote_address"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], :name => "associated_index"
  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "issues", :force => true do |t|
    t.integer  "product_id"
    t.integer  "creator_id"
    t.text     "content"
    t.integer  "importance_level"
    t.integer  "urgent_level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "issues", ["creator_id"], :name => "index_issues_on_creator_id"
  add_index "issues", ["importance_level"], :name => "index_issues_on_importance_level"
  add_index "issues", ["product_id"], :name => "index_issues_on_product_id"
  add_index "issues", ["urgent_level"], :name => "index_issues_on_urgent_level"

  create_table "lemmas", :force => true do |t|
    t.integer  "product_id"
    t.string   "cn_name"
    t.string   "en_name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lemmas", ["cn_name"], :name => "index_lemmas_on_cn_name"
  add_index "lemmas", ["en_name"], :name => "index_lemmas_on_en_name"
  add_index "lemmas", ["product_id"], :name => "index_lemmas_on_product_id"

  create_table "member_infos", :force => true do |t|
    t.integer "user_id",          :null => false
    t.string  "real_name"
    t.string  "phone_number"
    t.string  "bank_card_number"
    t.string  "deposit_bank"
    t.string  "address"
    t.string  "post_code"
  end

  create_table "online_records", :force => true do |t|
    t.integer  "user_id"
    t.string   "key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "online_records", ["key"], :name => "index_online_records_on_key"
  add_index "online_records", ["user_id"], :name => "index_online_records_on_user_id"

  create_table "products", :force => true do |t|
    t.string   "name",            :default => "", :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cover_file_name"
    t.string   "github_page"
  end

  create_table "stories", :force => true do |t|
    t.string   "status",        :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.text     "how_to_demo"
    t.text     "tips"
    t.integer  "time_estimate", :default => 8,  :null => false
  end

  create_table "story_assigns", :force => true do |t|
    t.integer  "story_id",   :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stream_story_links", :force => true do |t|
    t.integer  "stream_id",  :null => false
    t.integer  "story_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "streams", :force => true do |t|
    t.string   "title",      :default => "", :null => false
    t.integer  "product_id",                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name",                      :default => "", :null => false
    t.string   "hashed_password",           :default => "", :null => false
    t.string   "salt",                      :default => "", :null => false
    t.string   "email",                     :default => "", :null => false
    t.string   "sign"
    t.string   "activation_code"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.datetime "activated_at"
    t.string   "reset_password_code"
    t.datetime "reset_password_code_until"
    t.datetime "last_login_time"
    t.boolean  "send_invite_email"
    t.integer  "reputation",                :default => 0,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wiki_page_refs", :force => true do |t|
    t.integer  "product_id"
    t.string   "from_page_title"
    t.string   "to_page_title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wiki_pages", :force => true do |t|
    t.integer  "product_id"
    t.integer  "creator_id"
    t.string   "title"
    t.text     "content"
    t.integer  "latest_version"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "delta",          :default => true, :null => false
  end

end
