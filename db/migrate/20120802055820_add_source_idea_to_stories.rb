class AddSourceIdeaToStories < ActiveRecord::Migration
  def change
    add_column :stories, :source_idea_id, :integer
  end
end
