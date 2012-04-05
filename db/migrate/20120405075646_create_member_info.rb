class CreateMemberInfo < ActiveRecord::Migration
  def change
    create_table :member_infos do |t|
      t.integer  :user_id, :null => false
      t.string   :real_name
    end
  end
end
