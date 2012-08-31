class DropIssuesAndStoriesAssignTables < ActiveRecord::Migration
  def change
    drop_table :story_assigns
    drop_table :issue_assigns
    drop_table :milestone_issue_assigns
  end
end
