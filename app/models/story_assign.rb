class StoryAssign < ActiveRecord::Base
  belongs_to :story
  belongs_to :user
  
  validates :story, :user, :presence => true


  module UserMethods
    def self.included(base)
      base.has_many :story_assigns
      base.has_many :assigned_stories, :through => :story_assigns, :source => :story

      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      #Todo
    end
    
  end
end