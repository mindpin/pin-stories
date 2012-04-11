class AddTimeEstimateToStories < ActiveRecord::Migration
  def change
    add_column :stories, :time_estimate, :integer, :null=>false, :default=>8
  end
end
