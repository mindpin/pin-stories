class AddCreatorIdToStories < ActiveRecord::Migration
  def change
  	add_column(:stories, :creator_id, :integer)
  end
end
