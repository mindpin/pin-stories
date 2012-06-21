class WikiController < ApplicationController

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

    if title.blank? || content.blank?
      render :text=>'尝试预览时未填写标题或内容'
    else
      wiki_page = current_user.wiki_pages.build({:title => title, :content => content})



      @title = params[:title]
      @content = wiki_page.formatted_content
      @relative_search = WikiPageRecommander.recommand_by_content(@product, content)

      render :layout => false
    end
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
  
  # 所有记录的版本回滚
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

  # 添加 Evernote 页面
  def new_evernote
    session[:oauth_verifier] = nil
    session[:notebook_name] = nil
    session[:tag_names] = nil
    @product_id = params[:product_id]
  end

  # 导入 Evernote
  def import_evernote
    session[:notebook_name] = params[:notebook_name]
    session[:tag_names] = params[:tag_names]

    if current_user.hasEvernoteAuth?
      product_id = params[:product_id]
      notebook_name = session[:notebook_name]
      user_evernote_auth = UserEvernoteAuth.find_by_user_id(current_user.id)
      dump_access_token = user_evernote_auth.access_token
      access_token = Marshal.load(dump_access_token)
      shard = user_evernote_auth.shard

      EvernoteData.import(current_user, product_id, access_token, shard, session[:notebook_name], session[:tag_names])

      # redirect_to "/products/#{product_id}/wiki"

    else
      consumer_key = params[:consumer_key]
      consumer_secret = params[:consumer_secret]
      
      callback_url = request.url.chomp("requesttoken").concat("callback")

      session[:request_token] = EvernoteData.request_token(consumer_key, consumer_secret, callback_url)

      redirect_to session[:request_token].authorize_url(:oauth_callback => callback_url)
    end
    

  end


  def import_evernote_callback
    session[:oauth_verifier] = params['oauth_verifier']
    notebook_name = session[:notebook_name]
    tag_names = session[:tag_names]

    access_token = session[:request_token].get_access_token(:oauth_verifier=> params['oauth_verifier'])
    product_id = params[:product_id]
    shard = access_token.params[:edam_shard]

    EvernoteData.import(current_user, product_id, access_token, shard, notebook_name, tag_names)

    dump_access_token = Marshal.dump(access_token)
    UserEvernoteAuth.create(
      :user_id => current_user.id, 
      :access_token => dump_access_token, 
      :shard =>  shard
    )

    #redirect_to "/products/#{product_id}/wiki"

  end



end
