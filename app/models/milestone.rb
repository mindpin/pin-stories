class Milestone < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :product, :class_name => 'Product', :foreign_key => :product_id
  
  has_many :root_usecases, 
           :conditions => lambda { "usecase_id = 0" },
           :class_name => 'UseCase', :foreign_key => :milestone_id


   has_many :reports,
            :class_name => 'MilestoneReport', :foreign_key => :milestone_id


  validates :product_id,  :presence => true


  def create_report(user)
    MilestoneReport.create(
      :milestone => self, 
      :product => self.product,
      :creator => user
    )
  end


  module UserMethods
    def self.included(base)
      base.has_many :milestones, :class_name => 'Milestone', :foreign_key => :creator_id

      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      
    end
    
  end
  # end of UserMethods
end
