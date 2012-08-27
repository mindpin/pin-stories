class DropUseCases < ActiveRecord::Migration
  def change
    drop_table :use_cases
  end
end
