class UserEvernoteAuth < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'

  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_one :evernote_auth, :class_name => 'UserEvernoteAuth', :foreign_key => :user_id

      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      def has_evernote_auth?
      	UserEvernoteAuth.where(:user_id => self.id).exists?
      end

      def get_evernote_access_token
        Marshal.load(self.evernote_auth.access_token)
      end
    end
  end
end
