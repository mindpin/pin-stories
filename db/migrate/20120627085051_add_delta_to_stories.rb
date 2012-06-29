class AddDeltaToStories < ActiveRecord::Migration
  def change
  	add_column(:stories, :delta, :boolean, :default => true, :null => false)
  end
end
