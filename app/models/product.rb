class Product < ActiveRecord::Base
  has_many :streams
  
  validates :title, :description, :presence => true
end