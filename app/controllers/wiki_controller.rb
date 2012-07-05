class WikiController < ApplicationController

  before_filter :login_required
  before_filter :pre_load
  def pre_load
    @product = Product.find(params[:product_id]) if params[:product_id]

    if !@product.nil? && !params[:title].blank?
      @wiki_page = @product.wiki_pages.find_by_title(params[:title])
    end
  end

  def index
    @wiki_pages = @product.wiki_pages
  end
  
  def show
  end

  def new
    @wiki_page = WikiPage.new
    render :layout=>'simple_form'
  end
  
  def create
    @wiki_page = current_user.wiki_pages.build(params[:wiki_page])
    @wiki_page.product = @product

    if @wiki_page.save
      redirect_to URI.encode("/products/#{@wiki_page.product_id}/wiki/#{@wiki_page.title}")
      return
    end

    flash[:error] = @wiki_page.errors.first
    return render :new, :layout=>'simple_form'
  end
  
  # 预览
  def preview
    title = params[:title]
    content = params[:content]

    wiki_page = WikiPage.new({
      :title   => title, 
      :content => content, 
      :product => @product,
      :creator => current_user,
      :preview => true
    })

    wiki_page.fix_title

    @title = wiki_page.title
    @content = wiki_page.formatted_content_for_preview

    @recommander_wiki_pages = WikiPageRecommander.recommand_by_content(@product, content)

    render :layout => false
  rescue Exception => e
    render :text=>"发生异常 #{e.class} : #{e}"
  end

  def edit
    render :layout=>'simple_form'
  end
  
  def update
    @wiki_page.update_attributes(params[:wiki_page])
    redirect_to URI.encode("/products/#{@wiki_page.product_id}/wiki/#{@wiki_page.title}")
  end
  
  def versions
    @audits = @wiki_page.audits.descending 
    # 参考audited源代码
    # https://github.com/collectiveidea/audited/blob/master/lib/audited/adapters/active_record/audit.rb
    # 23 行，通过这个scope使其按version反序排列
    # 此处还有一些scope会比较有用
  end
  
  # 单条记录的版本回滚
  def rollback
    audit = @wiki_page.audits.find_by_version(params[:version])
    @wiki_page.rollback_to(audit)
    
    redirect_to URI.encode("/products/#{@wiki_page.product_id}/wiki/#{@wiki_page.title}")
  end

  def destroy
    @wiki_page.destroy
    redirect_to "/products/#{@wiki_page.product_id}/wiki"
  end
  
  # ------------------------

  # 编辑内容区块页面
  def edit_section
    section_number = params[:section].to_i
    @content = WikiPageFormatter.split_section(@wiki_page, section_number)
  end

  def update_section
    section_number = params[:section].to_i

    @wiki_page.content = WikiPageFormatter.replace_section(@wiki_page, section_number, params[:content])
    @wiki_page.save

    redirect_to URI.encode("/products/#{@wiki_page.product_id}/wiki/#{@wiki_page.title}")
  end

  # 当前页面引用页
  def refs
    # 当前引用的
    @refs = WikiPageRef.where(:product_id => params[:product_id], :from_page_title => params[:title])

    # 引用当前的
    @used_refs = WikiPageRef.where(:product_id => params[:product_id], :to_page_title => params[:title])

  end

  # 没有被其他wiki页引用，也没有引用其他wiki页的页面
  def orphan
    wiki_pages = WikiPage.all

    @orphan_pages = []
    wiki_pages.each do |wiki_page|
      from = WikiPageRef.where(:product_id => wiki_page.product_id, :from_page_title => wiki_page.title).exists?
      to = WikiPageRef.where(:product_id => wiki_page.product_id, :to_page_title => wiki_page.title).exists?

      unless from || to
        @orphan_pages << wiki_page
      end

    end
  end

  # 全文索引，搜索
  def search
    @keyword = params[:keyword]
    @search_result = WikiPage.search(@keyword, 
      :conditions => {:product_id => @product.id}, 
      :page => params[:page], :per_page => 20)
  end



  def save_new_draft
    drafted_hash = {:title => params[:title], :content => params[:content], :product_id => params[:product_id]}
    temp_id = params[:temp_id] unless params[:temp_id].nil?

    temp_id = WikiPage.save_new_draft(current_user, drafted_hash, temp_id)

    render :text => temp_id
  end


  def save_draft
    wiki_id = params[:wiki_id]
    @wiki_page = WikiPage.find(wiki_id)

    drafted_hash = {
      :title => params[:title],
      :content => params[:content], 
      :product_id => @wiki_page.product_id
    }

    @wiki_page.save_draft(current_user, drafted_hash)

    render :nothing => true
  end



  def get_draft
    temp_id = params[:temp_id] 
    draft = Draft.find_by_temp_id(temp_id) unless temp_id.nil?

    wiki_id = params[:wiki_id]
    draft = Draft.where(:model_id => wiki_id, :model_type => "WikiPage").first unless wiki_id.nil?

    unless draft.nil?
      drafted_hash = Marshal.load(draft.drafted_hash)
      wiki = {:title => drafted_hash[:title], :content => drafted_hash[:content]}
    end

    render :text => wiki.to_json
  end

end
