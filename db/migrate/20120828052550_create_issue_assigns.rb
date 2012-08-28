class CreateIssueAssigns < ActiveRecord::Migration
  def change
    create_table :issue_assigns do |t|
      t.integer :issue_id
      t.integer :user_id

      t.timestamps
    end
  end
end
