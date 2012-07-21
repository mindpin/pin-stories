class Draft < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :model, :polymorphic => true


  module DraftableMethods
    def self.included(base)
      base.has_many :drafts, :as => :model
    end
  end


  module UserMethods
    def self.included(base)
      base.has_many :drafts, :class_name => 'Draft', :foreign_key => :creator_id
    end
    
  end
  
end
