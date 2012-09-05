class ChangeColumnsInIssues < ActiveRecord::Migration
  def change
    add_column :issues, :usecase_id, :integer
    add_column :issues, :milestone_report_id, :integer
    remove_column :issues, :importance_level
    remove_column :issues, :urgent_level
  end
end
