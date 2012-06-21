class FixLengthOfAccessToken < ActiveRecord::Migration
  def change
  	change_column :user_evernote_auths, :access_token, :text
  end

end
