class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :product_id
      t.integer :actor_id
      t.integer :act_model_id
      t.string  :act_model_type
      t.string  :action

      t.timestamps
    end
  end
end
