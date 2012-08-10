class CreateUseCases < ActiveRecord::Migration
  def change
    create_table :use_cases do |t|
      t.integer :creator_id
      t.integer :product_id
      t.integer :milestone_id
      t.integer :usecase_id
      t.string :content

      t.timestamps
    end
  end
end
