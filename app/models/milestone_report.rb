class MilestoneReport < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :milestone, :class_name => 'Milestone', :foreign_key => :milestone_id
  belongs_to :product, :class_name => 'Product', :foreign_key => :product_id
  
  has_many :issues

  validates :milestone, :product, :creator, :presence => true

  default_scope order('id DESC')

  before_validation :on => :create do |report|
    if !report.milestone.blank?
      report.product = report.milestone.product
    end
  end

  def open_issues_count
    issues.open_issues.count
  end

  def closed_issues_count
    issues.closed_issues.count
  end

  def pause_issues_count
    issues.pause_issues.count
  end

  def close
    self.state = 'CLOSED'
    self.save
  end

  module UserMethods
    def self.included(base)
      base.has_many :milestone_reports, :class_name => 'User', :foreign_key => :creator_id

      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      
    end
  end
  # end of UserMethods
  
end
