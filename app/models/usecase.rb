class Usecase < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :milestone, :class_name => 'Milestone', :foreign_key => :milestone_id
  belongs_to :product

  has_many :sub_usecases, :class_name => 'Usecase', :foreign_key => :usecase_id, :dependent => :destroy
  has_many :issues, :class_name => 'MilestoneIssue', :foreign_key => :usecase_id

  validates :product, :milestone, :presence => true

  module UserMethods
    def self.included(base)
      base.has_many :usecases, :class_name => 'Usecase', :foreign_key => :creator_id

      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
    end
  end
  
end
