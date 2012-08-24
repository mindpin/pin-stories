class CreateMilestones < ActiveRecord::Migration
  def change
    create_table :milestones do |t|
      t.integer :product_id
      t.integer :creator_id
      t.string  :name
      t.string  :state

      t.timestamps
    end
  end
end
