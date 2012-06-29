class Issue < ActiveRecord::Base

  belongs_to :product
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id

  validates :product, :creator, :content, :presence => true

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

  # 引用其它类
  include Activity::ActivityableMethods

  module UserMethods
    def self.included(base)
      base.has_many :story_assigns
      base.has_many :stories, :through => :story_assigns 
    end    
  end

end