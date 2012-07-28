class Comment < ActiveRecord::Base
  belongs_to :model, 
             :polymorphic => true

  belongs_to :creator, 
             :class_name => 'User', 
             :foreign_key => 'creator_id'

  belongs_to :receiver,
             :class_name => 'User',
             :foreign_key => 'receiver_id'

  belongs_to :reply_comment,
             :class_name => 'Comment', 
             :foreign_key => 'reply_comment_id'

  belongs_to :reply_user,
             :class_name => 'User', 
             :foreign_key => 'reply_comment_user_id'

  
  default_scope order('id DESC')
  scope :without_creator, lambda {|creator| {:conditions => ['creator_id <> ?', creator.id]}}

  validates :model, 
            :presence => true

  validates :content, 
            :presence => true

  validates :reply_comment_user_id, 
            :presence => {:if => Proc.new { |comment| !comment.reply_comment_id.blank? }}
    
  before_validation :set_reply_comment_user_id, :on => :create
  def set_reply_comment_user_id
    if !self.reply_comment_id.blank?
      self.reply_comment_user_id = reply_comment.creator_id
    end
  end

  after_create :send_tip_message_for_receiver_on_create
  def send_tip_message_for_receiver_on_create
    receiver = self.model.comment_receiver

    return true if receiver.blank?
    return true if receiver == self.creator

    receiver.comment_tip_message.put("#{self.creator.name} 给你发了评论", self.id)
    receiver.comment_tip_message.send_count_to_juggernaut
  end

  after_create :send_tip_message_for_reply_user_on_create
  def send_tip_message_for_reply_user_on_create
    reply_user = self.reply_user

    return true if reply_user.blank?
    return true if reply_user == self.creator

    reply_user.comment_tip_message.put("#{self.creator.name} 给你发了评论", self.id)
  end

  after_destroy :send_tip_message_on_destroy
  def send_tip_message_on_destroy
    receiver = self.model.comment_receiver

    if !receiver.blank?
      receiver.comment_tip_message.delete(self.id)
      receiver.comment_tip_message.send_count_to_juggernaut
    end
  end

  before_create :set_receiver_on_create
  def set_receiver_on_create
    self.receiver = self.model.comment_receiver
  end
  
  module CommentableMethods
    def self.included(base)
      base.has_many :comments, :as => :model
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def comment_receiver
        self.creator
      end

      def add_comment(creator, content)
        self.comments.create :creator => creator,
                             :content => content
      end
    end
  end

  module UserMethods
    def self.included(base)
      base.has_many :send_comments,
                    :class_name => 'Comment',
                    :foreign_key => 'creator_id'

      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def received_comments
        Comment.without_creator(self).where(
          'receiver_id = ? OR reply_comment_user_id = ?', self.id, self.id
        )
      end
    end
  end

end
