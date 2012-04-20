class Issue < ActiveRecord::Base

  belongs_to :product
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id

  validates :product, :creator, :content, :presence => true

  module UserMethods
    def self.included(base)
      base.has_many :story_assigns
      base.has_many :stories, :through => :story_assigns 
    end    
  end

end