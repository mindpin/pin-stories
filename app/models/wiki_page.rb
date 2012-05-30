class WikiPage < ActiveRecord::Base
  # --- 模型关联
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :product, :class_name => 'Product'
  audited

=begin

  HUMANIZED_ATTRIBUTES = {
    :title => ""
  }

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

=end
  


  # --- 校验方法
  
  validates_format_of :title, 
    :with => /^([^"^'^\\^\/]?[-A-Za-z0-9一-龥]+)$/,
    # :with => /^([A-Za-z0-9一-龥]+)$/,
    :message => "不允许出现 &, ?, ', \", \\, \/ 非法字符"


  validates_uniqueness_of :title, :message => "不能重复"
  #validates_presence_of :content, :message => "不能为空"



  before_validation :fix_title

  def fix_title
    if WikiPage.where(:title => self.title).exists?
      self.title = self.title + "-repeat"
      fix_title
    end

    # 如果有存在不合法字符，则替换掉
    self.title = self.title.gsub(/["'\\\/?&]+/, '-')
  end

  def is_title_repeat?
    WikiPage.where(:title => self.title).exists?
  end

  def generate_title_indices
    indices = Array.new
    
    self.content.each_line do |line| 
      line = line.chomp

      line.grep(/^[#]+[\s*]/){ |line|
        row = line.split(/^[#]+[\s*]/)
        text = '<a href="#' + row[1] + ' ">' + row[1] + '</a>'

        header = line.match(/^[#]+/)[0]

        case header.length
        when 1
          indices << text
          a += 1
        when 2
          #indexes << text
          indices << [text]
          b += 1
        when 3
          indices << [[text]]
          c += 1
        when 4
          indices << [[[text]]]
        when 5
          indices << [[[[text]]]]
        when 6
          indices << [[[[[text]]]]]
        else
          indices << text
        end
          
      }
    end
    indices


=begin
    self.content.grep(/^[#]+[\s*]/){ |line|
      row = line.split(/^[#]+[\s*]/)
      text = '<a href="#' + row[1] + ' ">' + row[1] + '</a>'

      indexes.push text
    }
=end

  end

  class HTMLwithCoderay < Redcarpet::Render::HTML
    def block_code(code, language)
      # 代码格式化选项参考
      # http://coderay.rubychan.de/doc/classes/CodeRay/Encoders/HTML.html

      CodeRay.scan(code, language).div(
        :tab_width    => 2,
        :css          => :class, # 稍后改成 :class 以自定义颜色
        :line_numbers => :inline,
        :line_number_anchors => false,
        :bold_every => false
      )
    end

    def normal_text(text)
      re = text
      # 转换 @某某 语法
      # return re.gsub(/@([A-Za-z0-9一-龥\/_]+)/, '<a href="/atme/\1">@\1</a>')

      re = re.gsub(/@([A-Za-z0-9一-龥\/_]+)/, '<a href="/atme/\1">@\1</a>')
      #content = re.gsub(/^\[\[([A-Za-z0-9一-龥\/_]+)\]\]$/, '<a href="/products/#{self.product_id}/wiki_page/\1">\1</a>')

      return re
    end

    # TODO 这里还可以做更多扩展
    # TODO 参考这个： http://dev.af83.com/2012/02/27/howto-extend-the-redcarpet2-markdown-lib.html
    # "How to extend the Redcarpet 2 Markdown library?"
  end

  def formated_content(content = '')
    self.content = content if self.content.blank?

    re = ''

    coderay_render = HTMLwithCoderay.new(
      :filter_html     => true,
      :safe_links_only => true,
      :hard_wrap       => true
    )

    markdown = Redcarpet::Markdown.new(coderay_render,
      :no_intra_emphasis   => true,
      :fenced_code_blocks  => true,
      :autolink            => true,
      :strikethrough       => true,
      :space_after_headers => true
    )

=begin
    new_content = ''
    self.content.each_line do |line| 
      line = line.chomp

      line.grep(/^[#]+[\s*]/){ |line|
        row = line.split(/^[#]+[\s*]/)
        if row.size > 0

          header = line.match(/^[#]+/)[0]
          text = header + ' <a name="' + row[1] + ' ">' + row[1] + '</a>'

          new_content = new_content + "\n" + text
        else
          new_content = new_content + "\n" + line
        end
      }
    end
    self.content = new_content
=end

    re = markdown.render(self.content)

    
    # 把中间的 ？ & 等特殊字符转化成 -
    re = re.gsub(/\[\[([A-Za-z0-9一-龥\/_]+)([?&]+)([A-Za-z0-9一-龥\/_]+)\]\]/, '[[\1-\3]]').html_safe

    # 根据 [[ruby]] 字符串匹配先生成url
    re = re.gsub(/\[\[([-A-Za-z0-9一-龥\/_]+)\]\]/, '[[<a href="/products/' + self.product_id.to_s + '/wiki/\1">\1</a>]]').html_safe
    
    # 将标题h1 - h6  增加相应的瞄点
    re = re.gsub(/\<h([1-6]{1})\>(.*)\<\/h([1-6]{1})\>/, '<h\1><a name="\2">\2</a></h\1>').html_safe
  end


  def versions
    audits.map{|audit|WikiPageVersion.new(audit)}
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


  def self.system_rollback(audit)
    audits = Audited::Adapters::ActiveRecord::Audit.unscoped.where('id > ?', audit.id).order("id DESC").all
    
    audits.each do |audit|
      case audit.action
        when 'create'
          wiki_page = audit.auditable
          wiki_page.destroy unless wiki_page.nil?
  
        when 'update'
          wiki_page = audit.auditable
          version = WikiPageVersion.new(audit)
  
          wiki_page.title = version.prev.title
          wiki_page.content = version.prev.content
          wiki_page.creator = version.prev.creator
          wiki_page.save
       
        when 'destroy'
          wiki_page = WikiPage.new
          version = WikiPageVersion.new(audit)
  
          wiki_page.id = audit.auditable_id
          wiki_page.title = version.title
          wiki_page.content = version.content
          wiki_page.creator = version.creator
          
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
