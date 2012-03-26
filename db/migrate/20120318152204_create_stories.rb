class CreateStories < ActiveRecord::Migration
  def change
    # 创建多个业务对象表
    
    create_table :products do |t|
      t.string :title, :null => false
      t.text   :description
      
      t.timestamps
    end
    
    create_table :streams do |t|
      t.string  :title, :null => false
      t.integer :product_id, :null => false
      
      t.timestamps
    end
    
    create_table :stream_story_links do |t|
      t.integer :stream_id, :null => false
      t.integer :story_id, :null => false
      
      t.timestamps
    end
    
    create_table :stories do |t|
      t.text   :content, :null => false # 故事描述
      t.string :status, :null => false # 故事状态，分为 NOT-ASSIGN, DOING, REVIEWING, DONE, PAUSE 五种
      
      t.timestamps
    end
    
    create_table :story_assigns do |t|
      t.integer :story_id, :null => false
      t.integer :user_id, :null => false
      
      t.timestamps
    end
  end
end
