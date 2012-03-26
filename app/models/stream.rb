class Stream < ActiveRecord::Base
  belongs_to :product
  has_many :stream_story_links
  has_many :stories, :through => :stream_story_links 
  
  validates :title, :product, :presence => true
end