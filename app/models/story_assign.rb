class StoryAssign < ActiveRecord::Base
  belongs_to :story
  belongs_to :user
  
  validates :story, :user, :presence => true
end