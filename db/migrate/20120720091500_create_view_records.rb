class CreateViewRecords < ActiveRecord::Migration
  def change
    create_table :view_records do |t|
      t.integer :viewer_id
      t.integer :work_result_id
      
      t.timestamps
    end
  end
end
