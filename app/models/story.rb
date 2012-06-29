class Story < ActiveRecord::Base
  STATUS_NOT_ASSIGN = 'NOT-ASSIGN'
  STATUS_DOING      = 'DOING'
  STATUS_REVIEWING  = 'REVIEWING'
  STATUS_DONE       = 'DONE'
  STATUS_PAUSE      = 'PAUSE'
  
  STATUSES = [
    STATUS_NOT_ASSIGN,
    STATUS_DOING,
    STATUS_REVIEWING,
    STATUS_DONE,
    STATUS_PAUSE
  ]
  
  # -------------------------
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  has_many :stream_story_links
  has_many :streams, :through => :stream_story_links
  accepts_nested_attributes_for :stream_story_links
  has_many :story_assigns
  has_many :users, :through => :story_assigns
  
  belongs_to :product

  # 调用历史回滚
  audited :only=>[:how_to_demo, :tips]
  
  # ------------------
  
  default_scope order('id DESC')
  
  scope :with_status, lambda {|status| where(:status=>status)}
  
  # ------------------
  
  validates :product,     :presence => true
  validates :how_to_demo, :presence => true
  validates :status,      :presence => true, :inclusion => {:in => STATUSES}
  
  validate :validate_stream_story_links_count
  def validate_stream_story_links_count
   if 0 == self.stream_story_links.length
      errors.add(:streams, :至少指定一个序列)
   end
  end
  
  before_validation(:on => :create) do
    self.status = STATUS_NOT_ASSIGN
  end


  # 生成 story 动态
  after_create :generate_create_activity
  after_update :generate_update_activity

  def generate_create_activity
    Activity.create(
      :product => self.product,
      :actor => self.creator,
      :act_model => self, 
      :action => 'CREATE_STORY'
    )
  end

  def generate_update_activity
    Activity.create(
      :product => self.product,
      :actor => self.creator,
      :act_model => self, 
      :action => 'UPDATE_STORY'
    )
  end
  
  # ----------------------
  
  def change_status(status)
    self.status = status
    self.save
  end


  # 回滚内容状态到指定的版本  
  def rollback_to(audit)
    if audit.auditable != self
      raise '你不能回滚到一个不属于本故事的版本记录'
    end

    self.how_to_demo = audit.revision.how_to_demo
    self.tips = audit.revision.tips
    self.save
  end


  # 引用其它类
  include Comment::CommentableMethods
  include Activity::ActivityableMethods
  
  # ----------------------
  
  module UserMethods
    def self.included(base)
      base.has_many :story_assigns
      base.has_many :stories, :through => :story_assigns 
      base.has_many :created_stories, :class_name => 'Story', :foreign_key => :creator_id
    end
    
    def is_admin?
      User.first == self # 第一个用户是管理员，暂时先这样判断
    end
    
    def assigned_stories
      self.stories
    end
    
  end


  # 设置全文索引字段
  define_index do
    # fields
    indexes how_to_demo, :sortable => true
    indexes tips
    indexes product_id
    
    # attributes
    has created_at, updated_at

    set_property :delta => true
  end
end
