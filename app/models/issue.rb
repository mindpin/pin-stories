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
  has_many :issue_assigns
  has_many :users, :through => :issue_assigns

  validates :product, :creator, :content, :presence => true

  scope :with_state, lambda {|state| where(:state => state)}

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

  # 引用其它类
  include Comment::CommentableMethods
  include Activity::ActivityableMethods

  module UserMethods
    def self.included(base)
      base.has_many :issues,
                    :class_name => 'Issue', 
                    :foreign_key => :creator_id
    end
  end

end