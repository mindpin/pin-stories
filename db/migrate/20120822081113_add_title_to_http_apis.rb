class AddTitleToHttpApis < ActiveRecord::Migration
  def change
    add_column(:http_apis, :title, :string)
  end
end
