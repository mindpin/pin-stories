class StreamStoryLink < ActiveRecord::Base
  belongs_to :stream
  belongs_to :story
  
end