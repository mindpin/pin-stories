class WikiController < ApplicationController

  def index
    @wiki_pages = WikiPage.all
  end
  
  def new
    @wiki_page = WikiPage.new
  end
  
  def create
    wiki_page = current_user.wiki_pages.build(params[:wiki_page])
    wiki_page.save

    redirect_to '/wiki'
  end
  
  def show
    @wiki_page = WikiPage.find(params[:id])
  end
  
  def edit
    @wiki_page = WikiPage.find(params[:id])
  end
  
  def update
    @wiki_page = WikiPage.find(params[:id])
    @wiki_page.update_attributes(params[:wiki_page])

    redirect_to '/wiki'
  end
  
  def destroy
    @wiki_page = WikiPage.find(params[:id])
    @wiki_page.destroy

    redirect_to '/wiki'
  end
  
  # 所有的版本历史记录列表
  def history
    @history = Audited::Adapters::ActiveRecord::Audit.unscoped.all
  end
  
  # 改动的版本列表
  def versions
    @wiki_page = WikiPage.find(params[:id])
    @versions = @wiki_page.audits
  end
  
  # 单条记录的版本回滚
  def page_rollback
    wiki_page = WikiPage.find(params[:auditable_id])
    audit = Audited::Adapters::ActiveRecord::Audit.find(params[:audit_id])
    wiki_page.rollback(audit)
    
    redirect_to "/wiki"

  end
  
  
  # 所有记录的版本回滚
  def rollback
    audit = Audited::Adapters::ActiveRecord::Audit.find(params[:audit_id])
    WikiPage.system_rollback(audit)
    
    redirect_to "/wiki"
  end
  

end
