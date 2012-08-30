class IssueAssign < ActiveRecord::Base
  belongs_to :issue
  belongs_to :user
  
  validates :issue, :user, :presence => true

  module UserMethods
    def self.included(base)
      base.has_many :issue_assigns
      base.has_many :assigned_issues, :through => :issue_assigns, :source => :issue

      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods

      def received_issue?(issue)
        if IssueAssign.where(:user_id => self.id, :issue_id => issue.id).exists?
          return true
        end
        return false
      end

      def receive_issue(issue)        
        unless received_issue?(issue)
          IssueAssign.create(:user => self, :issue => issue)
        end
      end
    end

  end
end
