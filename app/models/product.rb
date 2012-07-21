class Product < ActiveRecord::Base
  has_many :streams
  has_many :stories
  has_many :issues
  has_many :lemmas
  has_many :wiki_pages
  has_many :wiki_page_refs
  
  validates :name, :description, :presence => true
  
  validates_attachment_presence :cover
  
  # --- cover setting
  COVER_PATH = '/:class/:attachment/:id/:style/:basename.:extension'
  COVER_URL  = "http://storage.aliyun.com/#{OssManager::CONFIG['bucket']}#{COVER_PATH}"
  has_attached_file :cover,
    :styles => {
      :normal => '200x150#',
      :s100 => '100x100#',
      :s50 => '50x50#'
    },
    :default_style => :normal,
    :path => COVER_PATH,
    :url  => COVER_URL,
    :storage => :oss
  
  # ---
  
  # 参与过的成员
  def members
    stories = self.stories.all(:include=>[:users])
    stories.map{|story| story.users}.flatten.uniq.compact
  end
  
end