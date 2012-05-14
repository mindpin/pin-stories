class WikiPage < ActiveRecord::Base
  # --- 模型关联
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  audited

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
