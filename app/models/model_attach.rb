class ModelAttach < ActiveRecord::Base
  belongs_to :model, 
             :polymorphic => true


  # --- image setting
  IMAGE_PATH = '/:class/:attachment/:id/:style/:basename.:extension'
  IMAGE_URL  = "http://storage.aliyun.com/#{OssManager::CONFIG['bucket']}#{IMAGE_PATH}"
  has_attached_file :image,
    :styles => {
      :normal => '200x150#',
      :s100 => '100x100#',
      :s50 => '50x50#' 
    },
    :default_style => :normal,
    :path => IMAGE_PATH,
    :url  => IMAGE_URL,
    :storage => :oss



    module ModelAttachableMethods
      def self.included(base)
        base.has_many :model_attaches, :as => :model

        base.accepts_nested_attributes_for :model_attaches

        base.send(:include, InstanceMethods)
      end

      module InstanceMethods
        
      end
    end


end
