class AddGithubProjectIdToStories < ActiveRecord::Migration
  def change
    add_column :stories, :github_project_id, :integer
  end
end
