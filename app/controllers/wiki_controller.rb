class WikiController < ApplicationController

  def index
    @product = Product.find(params[:product_id]) if params[:product_id]
    @wiki_pages = @product.wiki_pages
  end
  
  def new
    @product = Product.find(params[:product_id]) if params[:product_id]
    @wiki_page = WikiPage.new
  end
  
  def create
    wiki_page = current_user.wiki_pages.build(params[:wiki_page])
    wiki_page.save

    redirect_to "/products/#{wiki_page.product_id}/wiki"
  end
  
  def show
    @wiki_page = WikiPage.find(params[:id])
  end
  
  def edit
    @wiki_page = WikiPage.find(params[:id])
    @wiki_page.product
  end
  
  def update
    @wiki_page = WikiPage.find(params[:id])
    @wiki_page.update_attributes(params[:wiki_page])

    redirect_to "/wiki/#{@wiki_page.id}"
  end
  
  def destroy
    @wiki_page = WikiPage.find(params[:id])
    @wiki_page.destroy

    redirect_to "/products/#{@wiki_page.product_id}/wiki"
  end
  
  # 所有的版本历史记录列表
  def history
    @history = Audited::Adapters::ActiveRecord::Audit.unscoped.all
  end
  
  # 改动的版本列表
  def versions
    @wiki_page = WikiPage.find(params[:id])
    @versions = @wiki_page.audits

    @product = Product.find(@wiki_page.product_id)
  end
  
  # 单条记录的版本回滚
  def page_rollback
    wiki_page = WikiPage.find(params[:auditable_id])
    audit = Audited::Adapters::ActiveRecord::Audit.find(params[:audit_id])
    wiki_page.rollback(audit)
    
    redirect_to "/wiki/#{wiki_page.id}"

  end
  
  
  # 所有记录的版本回滚
  def rollback
    audit = Audited::Adapters::ActiveRecord::Audit.find(params[:audit_id])
    WikiPage.system_rollback(audit)
    
    redirect_to "/wiki"
  end
  

  # 用于跳转到个人首页
  def atme
    user = User.find_by_name(params[:name])

    if user.nil?
      render :status=>404 
    else
      redirect_to "/members/#{user.id}"
    end
  end


  # 处理词条预览 markdown 解析
  def preview
    @title = params[:wiki_page][:title]
    @content = WikiPage.parse_conent(params[:wiki_page][:content])

    @product = Product.find(params[:wiki_page][:product_id])
  end
  

end
