class CreateLemmas < ActiveRecord::Migration
  def change
    create_table :lemmas do |t|
      t.integer :product_id

      t.string  :cn_name
      t.string  :en_name
      t.text    :description
      t.timestamps
    end

    add_index :lemmas, :product_id
    add_index :lemmas, :cn_name
    add_index :lemmas, :en_name
  end
end