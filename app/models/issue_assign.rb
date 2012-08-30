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
    end

  end
end
