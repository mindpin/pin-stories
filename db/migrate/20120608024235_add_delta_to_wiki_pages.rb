class AddDeltaToWikiPages < ActiveRecord::Migration
  def change
  	add_column(:wiki_pages, :delta, :boolean, :default => true, :null => false)
  end
end
