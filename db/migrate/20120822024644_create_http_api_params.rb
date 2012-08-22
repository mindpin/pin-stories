class CreateHttpApiParams < ActiveRecord::Migration
  def change
    create_table :http_api_params do |t|
      t.integer :http_api_id
      t.string :name
      t.boolean :need, :default => true
      t.string :desc

      t.timestamps
    end
  end
end
