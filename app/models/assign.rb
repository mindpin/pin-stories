class Assign < ActiveRecord::Base
  belongs_to :model,
             :polymorphic => true

  belongs_to :user             

  validates  :model,
             :presence => true

  validates  :user,
             :presence => true

  module AssignableMethods
    def self.included(base)
      base.has_many :user_assigns, :as => :model
      base.has_many :assigned_users, :through => :user_assigns
    end
  end
end
