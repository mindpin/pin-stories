class CreateIdea < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.text    :content
      t.integer :source_story_id
      t.integer :creator_id
    end
  end
end
