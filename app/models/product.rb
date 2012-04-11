class Product < ActiveRecord::Base
  has_many :streams
  has_many :stories
  
  validates :name, :description, :presence => true
  
  validates_attachment_presence :cover
  
  # --- cover setting
  has_attached_file :cover,
    :styles => {
      :normal => '200x150#',
      :s100 => '100x100#',
      :s50 => '50x50#'
    },
    :default_style => :normal,
    :path => "/:class/:attachment/:id/:style/:basename.:extension",
    :url  => "http://storage.aliyun.com/#{OssManager::CONFIG["bucket"]}/:class/:attachment/:id/:style/:basename.:extension",
    :storage => :oss
  
  # ---
  
end