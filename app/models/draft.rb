class Draft < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :model, :polymorphic => true


  def publish!
  	drafted_hash = Marshal.load(self.drafted_hash)

  	story = Story.create(
      :creator => self.creator,
      :product_id => drafted_hash[:product_id],
      :how_to_demo => drafted_hash[:how_to_demo],
      :tips => drafted_hash[:tips],
      :status => "NOT-ASSIGN"
     )
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
