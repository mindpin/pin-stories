class RemoveShardFromUserEvernoteAuths < ActiveRecord::Migration
  def up
    remove_column(:user_evernote_auths, :shard)
  end

  def down
  end
end
