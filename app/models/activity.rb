class Activity < ActiveRecord::Base
  belongs_to :product
  belongs_to :actor, :class_name=>"User", :foreign_key=>"actor_id"
  belongs_to :act_model, :polymorphic => true


  module ActivityableMethods
    def self.included(base)
      base.has_many :activities, :as=>:act_model
    end
  end

  module UserMethods
    def self.included(base)
      base.has_many :activities, :class_name=>"User", :foreign_key => :actor_id
    end
    
  end
end
