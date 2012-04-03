class Product < ActiveRecord::Base
  has_many :streams
  
  validates :title, :description, :presence => true
  
  validates_attachment_presence :cover
  
  # --- cover setting
  IMAGE_PATH = "/:class/:attachment/:id/:style/:basename.:extension"
  IMAGE_URL  = "http://storage.aliyun.com/#{OssManager::CONFIG["bucket"]}/:class/:attachment/:id/:style/:basename.:extension"

  has_attached_file :cover,
    :styles => {
      :normal => '200x150#',
      :s100 => '100x100#',
      :s50 => '50x50#'
    },
    :default_style => :normal,
    :path => IMAGE_PATH,
    :url  => IMAGE_URL,
    :storage => :oss
  
  # ---
  
end