class ChangeProductsAndStories < ActiveRecord::Migration
  def change
    rename_column :products, :title, :name
    add_column(:stories, :product_id, :integer)
  end
end
