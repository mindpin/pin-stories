class AddCommentIndex < ActiveRecord::Migration
  def change
    add_index :comments, [:model_id, :model_type]
    add_index :comments, :creator_id
    add_index :comments, :reply_comment_id
    add_index :comments, :reply_comment_user_id
    add_index :comments, :receiver_id
  end
end
