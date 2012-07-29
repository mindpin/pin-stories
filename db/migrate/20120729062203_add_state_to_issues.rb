class AddStateToIssues < ActiveRecord::Migration
  def change
    add_column(:issues, :state, :string, :default => 'OPEN')
  end
end
