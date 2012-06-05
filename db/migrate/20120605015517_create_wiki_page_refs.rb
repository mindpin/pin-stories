class CreateWikiPageRefs < ActiveRecord::Migration
  def change
    create_table :wiki_page_refs do |t|
      t.integer :product_id
      t.string :from_page_title
      t.string :to_page_title

      t.timestamps
    end
  end
end
