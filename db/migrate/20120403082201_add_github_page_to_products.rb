class AddGithubPageToProducts < ActiveRecord::Migration
  def change
    add_column(:products, :cover_file_name, :string)
    add_column(:products, :github_page, :string)
  end
end
