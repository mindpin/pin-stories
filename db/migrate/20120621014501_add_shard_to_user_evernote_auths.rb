class AddShardToUserEvernoteAuths < ActiveRecord::Migration
  def change
  	add_column(:user_evernote_auths, :shard, :string)
  end
end
