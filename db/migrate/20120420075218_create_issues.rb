class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.integer :product_id
      t.integer :creator_id
      t.text    :content
      t.integer :importance_level
      t.integer :urgent_level
      t.timestamps
    end
    
    add_index :issues, :product_id
    add_index :issues, :creator_id
    add_index :issues, :importance_level
    add_index :issues, :urgent_level
  end
end
