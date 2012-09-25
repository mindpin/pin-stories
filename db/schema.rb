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

ActiveRecord::Schema.define(:version => 20120924022835) do

  create_table "activities", :force => true do |t|
    t.integer  "product_id"
    t.integer  "actor_id"
    t.integer  "act_model_id"
    t.string   "act_model_type"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "comments", :force => true do |t|
    t.integer  "model_id"
    t.string   "model_type"
    t.integer  "creator_id"
    t.text     "content"
    t.integer  "reply_comment_id"
    t.integer  "reply_comment_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "receiver_id"
  end

  add_index "comments", ["creator_id"], :name => "index_comments_on_creator_id"
  add_index "comments", ["model_id", "model_type"], :name => "index_comments_on_model_id_and_model_type"
  add_index "comments", ["receiver_id"], :name => "index_comments_on_receiver_id"
  add_index "comments", ["reply_comment_id"], :name => "index_comments_on_reply_comment_id"
  add_index "comments", ["reply_comment_user_id"], :name => "index_comments_on_reply_comment_user_id"

  create_table "drafts", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "model_id"
    t.string   "model_type"
    t.string   "temp_id"
    t.text     "drafted_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "github_projects", :force => true do |t|
    t.integer  "product_id"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "github_users", :force => true do |t|
    t.integer  "user_id"
    t.string   "login"
    t.integer  "github_id"
    t.string   "avatar_url"
    t.string   "gravatar_id"
    t.string   "url"
    t.string   "name"
    t.string   "company"
    t.string   "blog"
    t.string   "location"
    t.string   "email"
    t.boolean  "hireadble"
    t.string   "bio"
    t.integer  "public_repos"
    t.integer  "public_gists"
    t.integer  "followers"
    t.integer  "following"
    t.string   "html_url"
    t.datetime "github_created_at"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "http_api_params", :force => true do |t|
    t.integer  "http_api_id"
    t.string   "name"
    t.boolean  "need",        :default => true
    t.string   "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "http_api_responses", :force => true do |t|
    t.integer  "http_api_id"
    t.string   "code"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "http_apis", :force => true do |t|
    t.integer  "creator_id"
    t.string   "request_type"
    t.string   "url"
    t.text     "logic"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "response_format"
  end

  create_table "ideas", :force => true do |t|
    t.text     "content"
    t.integer  "source_story_id"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "issue_assigns", :force => true do |t|
    t.integer  "issue_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "issues", :force => true do |t|
    t.integer  "product_id"
    t.integer  "creator_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",               :default => "OPEN"
    t.integer  "usecase_id"
    t.integer  "milestone_report_id"
  end

  add_index "issues", ["creator_id"], :name => "index_issues_on_creator_id"
  add_index "issues", ["product_id"], :name => "index_issues_on_product_id"

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
    t.string  "github_homepage"
  end

  create_table "milestone_issue_assigns", :force => true do |t|
    t.integer  "milestone_issue_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "milestone_issues", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "usecase_id"
    t.integer  "check_report_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",           :default => "OPEN"
  end

  create_table "milestone_reports", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "milestone_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "state",        :default => "OPEN", :null => false
  end

  create_table "milestones", :force => true do |t|
    t.integer  "product_id"
    t.integer  "creator_id"
    t.string   "name"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "model_attaches", :force => true do |t|
    t.integer  "model_id"
    t.string   "model_type"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "name",            :default => "",        :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cover_file_name"
    t.string   "github_page"
    t.string   "kind",            :default => "SERVICE", :null => false
  end

  create_table "stories", :force => true do |t|
    t.string   "status",            :default => "",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.text     "how_to_demo"
    t.text     "tips"
    t.integer  "time_estimate",     :default => 8,    :null => false
    t.boolean  "delta",             :default => true, :null => false
    t.integer  "creator_id"
    t.integer  "source_idea_id"
    t.integer  "github_project_id"
  end

  create_table "story_assigns", :force => true do |t|
    t.integer  "story_id",                     :null => false
    t.integer  "user_id",                      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "delta",      :default => true, :null => false
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

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "usecases", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "product_id"
    t.integer  "milestone_id"
    t.integer  "usecase_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_assigns", :force => true do |t|
    t.integer  "model_id"
    t.string   "model_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_evernote_auths", :force => true do |t|
    t.integer  "user_id"
    t.text     "access_token"
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

  create_table "view_records", :force => true do |t|
    t.integer  "viewer_id"
    t.integer  "work_result_id"
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
    t.boolean  "delta",           :default => true, :null => false
    t.integer  "from_model_id"
    t.string   "from_model_type"
  end

  create_table "work_results", :force => true do |t|
    t.integer  "creator_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "kind",               :default => "LOGIC", :null => false
  end

end
