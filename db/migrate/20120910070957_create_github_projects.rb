class CreateGithubProjects < ActiveRecord::Migration
  def change
    create_table :github_projects do |t|
      t.integer :product_id
      t.string :url

      t.timestamps
    end
  end
end
