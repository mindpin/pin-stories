class AddReceiverIdToComments < ActiveRecord::Migration
  def change
    add_column(:comments, :receiver_id, :integer)
  end
end
