class Stream < ActiveRecord::Base
  belongs_to :product
  has_many :stream_story_links
  has_many :stories, :through => :stream_story_links 
  
  validates :title, :product, :presence => true
  
  # ---
  
  # 目前积累的任务人时
  def working_hours
    self.stories.map{|x| x.time_estimate}.sum
  end
  
end