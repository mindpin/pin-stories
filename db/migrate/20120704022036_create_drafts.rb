class CreateDrafts < ActiveRecord::Migration
  def change
    create_table :drafts do |t|
      t.integer :creator_id
      t.integer :model_id
      t.string  :model_type
      t.string  :temp_id
      t.text    :drafted_hash

      t.timestamps
    end
  end
end
