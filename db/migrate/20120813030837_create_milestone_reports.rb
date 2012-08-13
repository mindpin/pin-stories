class CreateMilestoneReports < ActiveRecord::Migration
  def change
    create_table :milestone_reports do |t|
      t.integer :creator_id
      t.integer :milestone_id
      t.integer :product_id

      t.timestamps
    end
  end
end
