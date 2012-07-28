class UserCommentTipMessage < UserTipMessage
  def hash_name
    "user:tip:message:comment:#{self.user.id}"
  end

  def path
    "/comments/received"
  end

  module UserMethods
    def self.included(base)
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      def comment_tip_message
        UserCommentTipMessage.new(self)
      end
    end
  end
end