class AddStateToMilestoneReports < ActiveRecord::Migration
  def change
    add_column(:milestone_reports, :state, :string, :null=>false, :default => 'OPEN')
  end
end
