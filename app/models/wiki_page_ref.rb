class WikiPageRef < ActiveRecord::Base
  # --- 模型关联
  belongs_to :product, :class_name => 'Product'

end
