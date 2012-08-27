class CreateHttpApis < ActiveRecord::Migration
  def change
    create_table :http_apis do |t|
      t.integer :creator_id
      t.string :request_type
      t.string :url
      t.text :logic

      t.timestamps
    end
  end
end
