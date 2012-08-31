# -*- coding: utf-8 -*-
class Product < ActiveRecord::Base
  KIND_SERVICE = 'SERVICE'
  KIND_INHOUSE = 'INHOUSE'
  KIND_LAB     = 'LAB'

  KINDS = [
    KIND_SERVICE,
    KIND_INHOUSE,
    KIND_LAB
  ]

  KINDS_NAME = {
    KIND_SERVICE => '互联网服务',
    KIND_INHOUSE => '定制软件',
    KIND_LAB => '实验室'
  }

  KINDS_DESC = {
    KIND_SERVICE => '公共互联网服务，面向大众非特定用户。强调：简洁针对、单一功能、有趣、多人参与',
    KIND_INHOUSE => '针对特定机构和特定用户（包括 MINDPIN TEAM 自己）进行的定制开发软件。强调：安全、稳定、功能适应匹配',
    KIND_LAB => '实验性质的产品，代码集合或概念想法。强调新鲜、创意、酷炫'
  }

  has_many :streams
  has_many :stories
  has_many :issues
  has_many :lemmas
  has_many :wiki_pages
  has_many :wiki_page_refs
  has_many :milestones
  has_many :milestone_reports
  
  validates :name, 
            :description, 
            :presence => true
  
  validates :kind, 
            :presence => true, 
            :inclusion => {:in => KINDS}
  
  validates_attachment_presence :cover

  scope :with_kind, lambda {|kind| where(:kind => kind)}

  # --- cover setting
  COVER_PATH = '/:class/:attachment/:id/:style/:basename.:extension'
  COVER_URL  = "http://storage.aliyun.com/#{OssManager::CONFIG['bucket']}#{COVER_PATH}"
  has_attached_file :cover,
    :styles => {
      :normal => '200x150#',
      :s100 => '100x100#',
      :s50 => '50x50#'
    },
    :default_style => :normal,
    :path => COVER_PATH,
    :url  => COVER_URL,
    :storage => :oss
  
  # ---
  
  # 参与过的成员
  def members
    stories = self.stories.all(:include=>[:assigned_users])
    stories.map{|story| story.assigned_users}.flatten.uniq.compact
  end
  
end
