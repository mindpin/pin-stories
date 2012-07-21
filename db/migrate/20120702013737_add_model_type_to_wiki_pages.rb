class AddModelTypeToWikiPages < ActiveRecord::Migration
  def change
  	add_column(:wiki_pages, :from_model_id, :integer)
  	add_column(:wiki_pages, :from_model_type, :string)
  end
end
