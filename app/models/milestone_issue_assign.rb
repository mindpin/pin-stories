class MilestoneIssueAssign < ActiveRecord::Base
  belongs_to :milestone_issue
  belongs_to :user
  
  validates :milestone_issue, :user, :presence => true

  module UserMethods
    def self.included(base)
      base.has_many :milestone_issue_assigns
      base.has_many :assigned_milestone_issues, :through => :milestone_issue_assigns, :source => :milestone_issue

      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods

      def received_milestone_issue?(milestone_issue)
        if MilestoneIssueAssign.where(:user_id => self.id, :milestone_issue_id => milestone_issue.id).exists?
          return true
        end
        return false
      end

      def receive_milestone_issue(milestone_issue)        
        unless received_issue?(milestone_issue)
          MilestoneIssueAssign.create(:user => self, :issue => milestone_issue)
        end
      end
    end

  end
end
