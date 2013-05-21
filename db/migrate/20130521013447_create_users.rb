class CreateUsers < ActiveRecord::Migration
  def up
  create_table "users", :force => true do |t|
    t.string    "email",                                                :null => false
    t.string    "crypted_password",                                     :null => false
    t.string    "password_salt",                                        :null => false
    t.string    "persistence_token",                                    :null => false
    t.string    "single_access_token",                                  :null => false
    t.string    "perishable_token",                                     :null => false
    t.integer   "login_count",                      :default => 0,      :null => false
    t.integer   "failed_login_count",               :default => 0,      :null => false
    t.timestamp "last_request_at",     :limit => 6
    t.timestamp "current_login_at",    :limit => 6
    t.timestamp "last_login_at",       :limit => 6
    t.string    "current_login_ip"
    t.string    "last_login_ip"
    t.timestamp "created_at",          :limit => 6
    t.timestamp "updated_at",          :limit => 6
    # t.string    "role_name"
    # t.string    "first_name"
    # t.string    "last_name"
    # t.string    "cell_phone"
    # t.string    "office_phone"
    # t.integer   "dealership_id"
    # t.string    "company"
    # t.boolean   "blocked",                          :default => false,  :null => false
    # t.string    "zipcode"
    # t.string    "address"
    # t.string    "address2"
    # t.integer   "us_state_id"
    # t.string    "city"
    # t.boolean   "activated",                        :default => true,   :null => false
    # t.string    "fax"
    # t.boolean   "allow_emails",                     :default => false,  :null => false
    # t.string    "logo_file_name"
    # t.string    "logo_content_type"
    # t.integer   "logo_file_size"
    # t.datetime  "logo_updated_at"
    # t.string    "website"
    # t.string    "carfax_dealer_type",               :default => "none", :null => false
    # t.string    "carfax_uid"
    # t.string    "carfax_password"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  end

  def down
  end
end
