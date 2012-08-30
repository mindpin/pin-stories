class MilestoneIssue < ActiveRecord::Base
  class State
    OPEN   = 'OPEN'
    CLOSED = 'CLOSED'
    PAUSE  = 'PAUSE'
  end

  STATES = [
    MilestoneIssue::State::OPEN,
    MilestoneIssue::State::CLOSED,
    MilestoneIssue::State::PAUSE
  ]


  belongs_to :creator, :class_name => 'User', 
                       :foreign_key => :creator_id

  belongs_to :milestone_report, :class_name => 'MilestoneReport', 
                                :foreign_key => :check_report_id

  belongs_to :usecase, :class_name => 'Usecase', 
                       :foreign_key => :usecase_id


  validates :creator_id, :check_report_id, :usecase_id, :content, :presence => true

  validates :state, :presence => true,
                    :inclusion => MilestoneIssue::STATES

  scope :with_state, lambda {|state| where(:state=>state)}
  scope :of_report, lambda {|report| where(:check_report_id=>report.id)}

  scope :closed_issues, with_state(MilestoneIssue::State::CLOSED)
  scope :pause_issues, with_state(MilestoneIssue::State::PAUSE)
  scope :open_issues, with_state(MilestoneIssue::State::OPEN)


  module UserMethods
    def self.included(base)
      base.has_many :milestone_issues, :foreign_key => :creator_id

      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods      
    end
  end
  
end
