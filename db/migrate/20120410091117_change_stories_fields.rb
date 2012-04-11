class ChangeStoriesFields < ActiveRecord::Migration
  def change
    add_column(:stories, :how_to_demo, :text)
    add_column(:stories, :tips, :text)
    remove_column(:stories, :content)
  end
end
