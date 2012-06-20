class CreateUserEvernoteAuths < ActiveRecord::Migration
  def change
    create_table :user_evernote_auths do |t|
      t.integer :user_id
      t.string :access_token

      t.timestamps
    end
  end
end
