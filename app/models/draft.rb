class Draft < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :model, :polymorphic => true
  
  default_scope order('id DESC')

  def load_hash
    Marshal.load self.drafted_hash
  end

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
