class StoryAssign < ActiveRecord::Base
  belongs_to :story
  belongs_to :user
  
  validates :story, :user, :presence => true


  module UserMethods
    def self.included(base)
      base.has_many :story_assigns
      base.has_many :assigned_stories, :through => :story_assigns, :source => :story
    end    
  end


  # 设置全文索引字段
  define_index do
    # fields
    indexes story(:how_to_demo)
    indexes story(:tips)
    indexes :user_id
    
    # attributes
    has :created_at, :updated_at

    set_property :delta => true
  end

end