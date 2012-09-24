class CreateModelAttaches < ActiveRecord::Migration
  def change
    create_table :model_attaches do |t|

      t.integer :model_id
      t.string :model_type
      
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at

      t.timestamps
    end
  end
end
