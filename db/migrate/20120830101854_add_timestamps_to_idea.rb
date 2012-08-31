class AddTimestampsToIdea < ActiveRecord::Migration
  def change
    add_column :ideas, :created_at, :datetime
    add_column :ideas, :updated_at, :datetime
  end
end
