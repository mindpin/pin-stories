# -*- coding: utf-8 -*-
class ViewRecord < ActiveRecord::Base
  belongs_to :viewer, :class_name => 'User', :foreign_key => :viewer_id
  belongs_to :work_result, :class_name => 'WorkResult', :foreign_key => :work_result_id

  validates :viewer_id, :presence => true,:uniqueness => {:scope => :work_result_id}
  validates :work_result, :presence => true


  after_create :send_tip_message_after_create
  def send_tip_message_after_create
    receiver = self.work_result.creator

    if self.work_result.is_hot? &&
       !receiver.hot_work_tip_message.get(self.work_result.id).blank?

      receiver.hot_work_tip_message.put('你的一个工作成果成为热门', self.work_result.id)
      receiver.hot_work_tip_message.send_count_to_juggernaut
    end
  end

  # begin UserMethods
  module UserMethods
    def self.included(base)
      base.has_many :view_recordss, :class_name => 'ViewRecord', :foreign_key => :viewer_id

      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      #Todo
    end
  end
  # end UserMethods


end
