class AddDeltaToStoryAssigns < ActiveRecord::Migration
  def change
  	add_column(:story_assigns, :delta, :boolean, :default => true, :null => false)
  end
end
