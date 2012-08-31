# -*- coding: utf-8 -*-
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
  
  # 参与过的成员
  def members
    stories = self.stories.all(:include=>[:assigned_users])
    stories.map{|story| story.assigned_users}.flatten.uniq.compact
  end
  
end
