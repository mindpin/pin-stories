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
      base.has_many :assigns,
                    :as => :model
    end
  end

  module UserMethods
    def self.included(base)
      base.has_many :assigns
    end
  end
end
