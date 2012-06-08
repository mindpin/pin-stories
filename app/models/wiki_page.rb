class WikiPage < ActiveRecord::Base
  # --- 模型关联
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :product, :class_name => 'Product'
  audited


  # --- 校验方法
  
  validates_format_of :title, 
    :with => /^([^"^'^\\^\/]?[\s*-A-Za-z0-9一-龥]+)$/,
    # :with => /^([A-Za-z0-9一-龥]+)$/,
    :message => "不允许出现 &, ?, ', \", \\, \/ 非法字符"


  validates_uniqueness_of :title, :message => "不能重复"
  #validates_presence_of :content, :message => "不能为空"


  # 在保存之前先验证并纠正title
  before_validation :fix_title_on_update, :on => :update
  before_validation :fix_title_on_create, :on => :create

  def fix_title_on_create
    if WikiPage.where("title = ?", self.title).exists?
      self.title = self.title + "-repeat"
      fix_title_on_create
    end

    # 如果有存在不合法字符，则替换掉
    self.title = self.title.gsub(/["'\\\/?&]+/, '-')
  end

  def fix_title_on_update
    if WikiPage.where("id != ? and title = ?", self.id, self.title).exists?
      self.title = self.title + "-repeat"
      fix_title_on_update
    end

    # 如果有存在不合法字符，则替换掉
    self.title = self.title.gsub(/["'\\\/?&]+/, '-')
  end

  
  # 保存到数据库后，把引用url存到表里面
  after_save :save_refs

  def save_refs
    to_page_titles = []
    self.content.each_line do |line|
      if line =~ /\[\[(.*)\]\]/
        to_page_titles << line.match(/\[\[(.*)\]\]/)[0].gsub(/\[\[(.*)\]\]/, '\1')
      end
    end
    to_page_titles.uniq

    WikiPageRef.destroy_all(:product_id => self.product_id, :from_page_title => self.title)

    to_page_titles.each do |to_page_title|
      wiki_page_ref = WikiPageRef.new
      wiki_page_ref.product = self.product 
      wiki_page_ref.from_page_title = self.title
      wiki_page_ref.to_page_title = to_page_title
      wiki_page_ref.save
    end
  end

  # 判断词条标题是否重复
  def is_title_repeat?
    WikiPage.where(:title => self.title).exists?
  end

  def formatted_content
    WikipageFormatter.format(self)
    # WikipageFormatter 代码位于 /lib/wiki
  end

  # ----- 版本控制相关

  def versions
    audits.map{|audit| WikiPageVersion.new(audit)}
  end
  
  def rollback(audit)
    audits = Audited::Adapters::ActiveRecord::Audit.unscoped.where('id > ? and auditable_id = ?', audit.id, self.id).order("id DESC").all

    audits.each do |audit|
      case audit.action
        when 'create'
          wiki_page = WikiPage.find(self.id)
          wiki_page.destroy
  
        when 'update'
          version = WikiPageVersion.new(audit)
          self.title = version.prev.title
          self.content = version.prev.content
          self.creator = version.prev.creator
          self.save
        when 'destroy'
          version = WikiPageVersion.new(audit)

          wiki_page = WikiPage.new(
            :id => audit.auditable_id,
            :title => version.title,
            :content => version.content,
            :creator => version.creator
          )
          wiki_page.save
      end
    end
  end
  

  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_many :wiki_pages, :foreign_key => :creator_id

      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      #Todo
    end
  end
end
