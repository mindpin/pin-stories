class AddStateToMilestoneIssues < ActiveRecord::Migration
  def change
    add_column :milestone_issues, :state, :string, :default => 'OPEN'
  end
end
