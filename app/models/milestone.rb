class Milestone < ActiveRecord::Base
  class State
    CLOSED = 'CLOSED'
    OPEN = 'OPEN'
  end

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :product, :class_name => 'Product', :foreign_key => :product_id
  
  has_many :root_usecases, 
           :conditions => lambda { "usecase_id = 0" },
           :class_name => 'Usecase', :foreign_key => :milestone_id


  has_many :reports,
            :class_name => 'MilestoneReport', :foreign_key => :milestone_id

  has_many :open_reports, 
           :conditions => lambda { "state = 'OPEN'" },
           :class_name => 'MilestoneReport', :foreign_key => :milestone_id


  validates :product_id,  :presence => true
  validates :creator_id,  :presence => true
  validates :name,        :presence => true
  validates :state,       :presence => true,
    :inclusion => [Milestone::State::OPEN,Milestone::State::CLOSED]

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
