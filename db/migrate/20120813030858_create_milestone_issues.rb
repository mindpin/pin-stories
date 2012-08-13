class CreateMilestoneIssues < ActiveRecord::Migration
  def change
    create_table :milestone_issues do |t|
      t.integer :creator_id
      t.integer :usecase_id
      t.integer :check_report_id
      t.text :content

      t.timestamps
    end
  end
end
