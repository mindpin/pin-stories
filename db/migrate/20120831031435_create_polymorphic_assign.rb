class CreatePolymorphicAssign < ActiveRecord::Migration
  def change
    create_table :assigns do |t|
      t.integer :model_id
      t.string  :model_type
      t.integer :user_id
      t.timestamps
    end

  end

end
