class CreateMilestoneIssueAssigns < ActiveRecord::Migration
  def change
    create_table :milestone_issue_assigns do |t|
      t.integer :milestone_issue_id
      t.integer :user_id

      t.timestamps
    end
  end
end
