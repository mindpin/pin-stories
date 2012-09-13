class GithubUser < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id


  module UserMethods
    def self.included(base)
      base.has_one :github_user, :class_name => 'GithubUser', :foreign_key => :user_id

      base.send(:include, InstanceMethods)
    end

    module InstanceMethods

      def save_github_user_from_api(github_user) 

        if !self.github_user.nil?
          self.github_user.destroy
        end

        hireadble = false
        hireadble = true if github_user['hireadble'] == 'true'

        GithubUser.create(
          :user => self,
          :url => github_user['url'],
          :html_url => github_user['html_url'],
          :avatar_url => github_user['avatar_url'],
          :location => github_user['location'],
          :public_gists => github_user['public_gists'],
          :gravatar_id => github_user['gravatar_id'],
          :company => github_user['company'],
          :public_repos => github_user['public_repos'],
          :login => github_user['login'],
          :following => github_user['following'],
          :github_id => github_user['id'],
          :name => github_user['name'],
          :github_created_at => github_user['created_at'],
          :blog => github_user['blog'],
          :email => github_user['email'],
          :type => github_user['type'],
          :bio => github_user['bio'],
          :followers => github_user['followers'],
          :hireadble => github_user['hireadble']
        )
      end
    end

  end
end
