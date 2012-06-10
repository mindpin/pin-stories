class WikiPage < ActiveRecord::Base
  # --- 模型关联
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :product, :class_name => 'Product'

  audited


  # --- 校验方法
  
  validates_format_of :title, 
    :with => /^([A-Za-z0-9一-龥-]+)$/,
    :message => "标题不允许非法字符"


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
    # wiki_page_formatter.rb 代码位于 /lib/wiki
    WikiPageFormatter.format(self)
  end


  # 回滚内容状态到指定的版本  
  def rollback_to(audit)
    if audit.auditable != self
      raise '你不能回滚到一个不属于本词条的版本记录'
    end

    audit_content = case audit.action
      when 'create'
        audit.audited_changes['content']
      when 'update'
        audit.audited_changes['content'].last
    end

    self.content = audit_content
    self.save
  end

  def split_section(section_num)
    WikiPageFormatter.split_section(self, section_num)
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
