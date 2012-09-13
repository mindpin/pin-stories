class AddGithubHomepageToMemberInfos < ActiveRecord::Migration
  def change
    add_column :member_infos, :github_homepage, :string
  end
end
