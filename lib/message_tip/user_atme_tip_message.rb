class UserAtmeTipMessage < UserTipMessage
  def hash_name
    "user:tip:message:atme:#{self.user.id}"
  end

  def path
    "/atme"
  end

  module UserMethods
    def self.included(base)
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      def atme_tip_message
        UserAtmeTipMessage.new(self)
      end
    end
  end
end