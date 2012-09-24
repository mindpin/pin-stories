# -*- coding: utf-8 -*-
class Issue < ActiveRecord::Base

  STATE_OPEN = 'OPEN'
  STATE_CLOSED = 'CLOSED'
  STATE_PAUSE = 'PAUSE'

  STATES = [
    STATE_OPEN,
    STATE_CLOSED,
    STATE_PAUSE
  ]

  belongs_to :product
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id

  belongs_to :milestone_report
  belongs_to :usecase

  validates :creator, :content, :presence => true
  validates :state, :presence => true,
                    :inclusion => Issue::STATES

  validates :product, :presence => true

  validates :milestone_report, :presence => {:if => Proc.new { |issue| issue.product.blank? }}
  validates :usecase, :presence => {:if => Proc.new { |issue| issue.product.blank? }}

  default_scope order('id DESC')

  scope :of_report, lambda {|report| where(:milestone_report_id => report.id)}
  scope :not_of_report, :conditions => ['milestone_report_id IS NULL']

  scope :with_state, lambda {|state| where(:state => state)}
  
  scope :open_issues, with_state(Issue::STATE_OPEN)
  scope :pause_issues, with_state(Issue::STATE_PAUSE)
  scope :closed_issues, with_state(Issue::STATE_CLOSED)



  before_validation(:on => :create) do |issue|
    if issue.product.blank? && !issue.usecase.blank?
      issue.product = issue.usecase.product
    end
  end

  # 生成 issue 动态
  after_create :generate_create_activity
  def generate_create_activity
    Activity.create(
      :product => self.product,
      :actor => self.creator,
      :act_model => self, 
      :action => 'CREATE_ISSUE'
    )
  end

  def closed?
    self.state == STATE_CLOSED
  end

  def pause?
    self.state == STATE_PAUSE
  end

  module UserMethods
    def self.included(base)
      base.has_many :issues,
                    :class_name  => 'Issue', 
                    :foreign_key => :creator_id

      base.has_many :assigned_issues,
                    :through     => :user_assigns,
                    :source      => :model,
                    :source_type => 'Issue'
    end
  end

  # 引用其它类
  include Comment::CommentableMethods
  include ModelAttach::ModelAttachableMethods
  include Activity::ActivityableMethods
  include UserAssign::AssignableMethods
end
