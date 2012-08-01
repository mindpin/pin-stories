class AddKindToWorkResults < ActiveRecord::Migration
  def change
  	add_column(:work_results, :kind, :string, :default => 'LOGIC', :null => false)
  end
end
