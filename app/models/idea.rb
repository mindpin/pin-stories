class Idea < ActiveRecord::Base
  belongs_to :creator,
             :class_name  => 'User',
             :foreign_key => :creator_id

  belongs_to :source_story,
             :class_name  => 'Story',
             :foreign_key => :source_story_id

  has_many   :stories,
             :foreign_key => :source_idea_id


  validates :content, :creator, :presence => true

  default_scope order('created_at DESC')

  include Comment::CommentableMethods

  module UserMethods
    def self.included(base)
      base.has_many :ideas,
                    :foreign_key => :creator_id
    end
  end
end
