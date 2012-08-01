# -*- coding: utf-8 -*-
class WorkResult < ActiveRecord::Base
  class Kind
    UI = "UI"
    LOGIC = "LOGIC"
    CONCEPT = "CONCEPT"
  end

  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  has_many :view_records
  
  has_attached_file :image,  :styles => { :medium => "300x300>", :thumb => "100x100>" }
                    # :path => "/web/2012/:class/:id/:style/:basename.:extension",
                    # :url => "/web/2012/:class/:id/:style/:basename.:extension"

  
  # Tags
  acts_as_ordered_taggable

  validates :creator, :presence => true
  validates :description, :presence => true
  validates :kind, :presence => true, :inclusion => [Kind::UI,Kind::LOGIC,Kind::CONCEPT]


  # 创建查看记录
  def create_view_record(user)
    # 如果是自己查看自己页面就直接返回
    if self.creator_id == user.id
      return false
    end

    view_record = ViewRecord.find_or_initialize_by_viewer_id_and_work_result_id user.id, self.id

    # 如果没有查看过，才添加相关的记录
    if view_record.new_record?
      return view_record.save
    end

    view_record.touch
    view_record.save
  end
  # end create_view_record

  def is_hot?
    self.view_records.count / (User.count-1) > 0.5
  end

  # 引用其它类
  include Comment::CommentableMethods

  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_many :work_results, :class_name => 'WorkResult', :foreign_key => 'creator_id'
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
    
    end
  end
  # end UserMethods
  
end
