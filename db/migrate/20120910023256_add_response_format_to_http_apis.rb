class AddResponseFormatToHttpApis < ActiveRecord::Migration
  def change
    add_column :http_apis, :response_format, :string
  end
end
