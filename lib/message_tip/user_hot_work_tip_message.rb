class UserHotWorkTipMessage < UserTipMessage
  def hash_name
    "user:tip:message:hotwork:#{self.user.id}"
  end

  def path
    '/hotworks'
  end

  module UserMethods
    def self.included(base)
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      def hot_work_tip_message
        UserHotWorkTipMessage.new(self)
      end
    end
  end
end
