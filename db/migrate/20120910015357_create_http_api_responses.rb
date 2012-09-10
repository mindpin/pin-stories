class CreateHttpApiResponses < ActiveRecord::Migration
  def change
    create_table :http_api_responses do |t|
      t.integer :http_api_id
      t.string :code
      t.text :content

      t.timestamps
    end
  end
end
