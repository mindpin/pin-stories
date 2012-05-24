class WikiPage < ActiveRecord::Base
  # --- 模型关联
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :product, :class_name => 'Product'
  audited


  # --- 校验方法
  validates :product, :title, :content, :presence => true


  class HTMLwithCoderay < Redcarpet::Render::HTML
    def block_code(code, language)
      # 代码格式化选项参考
      # http://coderay.rubychan.de/doc/classes/CodeRay/Encoders/HTML.html

      CodeRay.scan(code, language).div(
        :tab_width    => 2,
        :css          => :style, # 稍后改成 :class 以自定义颜色
        :line_numbers => :inline,
        :line_number_anchors => false
      )
    end
  end

  def formated_content
    rndr = HTMLwithCoderay.new(
      :filter_html     => true,
      :safe_links_only => true,
      :hard_wrap       => true
    )

    markdown = Redcarpet::Markdown.new(rndr,
      :no_intra_emphasis   => true,
      :fenced_code_blocks  => true,
      :autolink            => true,
      :strikethrough       => true,
      :space_after_headers => true
    )

    return markdown.render(self.content).html_safe

    # # 转换 @某某 语法
    # content.gsub(/@([A-Za-z0-9一-龥\/_]+)/,'<a href="/atme/\1">@\1</a>')

    # # html_safe 声明
    # content.html_safe
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
