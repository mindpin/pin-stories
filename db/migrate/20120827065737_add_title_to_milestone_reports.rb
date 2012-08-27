class AddTitleToMilestoneReports < ActiveRecord::Migration
  def change
    add_column(:milestone_reports, :title, :string)
  end
end
