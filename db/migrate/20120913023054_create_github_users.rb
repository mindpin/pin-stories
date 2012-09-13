class CreateGithubUsers < ActiveRecord::Migration
  def change
    create_table :github_users do |t|
      t.integer :user_id
      t.string :login
      t.integer :github_id
      t.string :avatar_url
      t.string :gravatar_id
      t.string :url
      t.string :name
      t.string :company
      t.string :blog
      t.string :location
      t.string :email
      t.boolean :hireadble
      t.string :bio
      t.integer :public_repos
      t.integer :public_gists
      t.integer :followers
      t.integer :following
      t.string :html_url
      t.datetime :github_created_at
      t.string :type

      t.timestamps
    end
  end
end
