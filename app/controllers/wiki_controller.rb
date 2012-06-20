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
    session[:notebook] = nil
    @product_id = params[:product_id]
  end

  # 导入 Evernote
  def import_evernote
    consumer_key = params[:consumer_key]
    consumer_secret = params[:consumer_secret]
    session[:notebook] = params[:notebook]

    callback_url = request.url.chomp("requesttoken").concat("callback")

    consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {
        :site => 'https://sandbox.evernote.com/',
        :request_token_path => "/oauth",
        :access_token_path => "/oauth",
        :authorize_path => "/OAuth.action"})


    session[:request_token] = consumer.get_request_token(:oauth_callback => callback_url)
    session[:request_token].authorize_url(:oauth_callback => callback_url)

    if current_user.hasEvernoteAuth?
      access_token = UserEvernoteAuth.find_by_user_id(current_user.id).access_token

      evernoteHost = "sandbox.evernote.com"
      userStoreUrl = "https://#{evernoteHost}/edam/user"
      noteStoreUrlBase = "https://#{evernoteHost}/edam/note/"


      noteStoreUrl = noteStoreUrlBase + access_token.params[:edam_shard]
      noteStoreTransport = Thrift::HTTPClientTransport.new(noteStoreUrl)
      noteStoreProtocol = Thrift::BinaryProtocol.new(noteStoreTransport)
      noteStore = Evernote::EDAM::NoteStore::NoteStore::Client.new(noteStoreProtocol)

      notebooks = noteStore.listNotebooks(access_token.token)

      notebooks.each do |notebook|
        filter = Evernote::EDAM::NoteStore::NoteFilter.new
        filter.notebookGuid = notebook.guid
        limit = 1000
        offset  =0
        note_list = noteStore.findNotes access_token.token, filter, offset, limit 

        note_list.notes.each do |note|
          p 887788778877887788778877887788778877
          p note.title
          p 99999999999999999999999999999999999
          WikiPage.create(
            :creator_id => current_user.id, 
            :product_id => params[:product_id], 
            :title => note.title,
            :content => note.content
          )
        end
      end
    else
      redirect_to session[:request_token].authorize_url(:oauth_callback => callback_url)
    end
    
  end


  def import_evernote_callback
    session[:oauth_verifier] = params['oauth_verifier']

    access_token = session[:request_token].get_access_token(:oauth_verifier=> params['oauth_verifier'])

    p 111111111111111111111111111111111
    p access_token.token
    p 2222222222222222222222222222222222222222

    evernoteHost = "sandbox.evernote.com"
    userStoreUrl = "https://#{evernoteHost}/edam/user"
    noteStoreUrlBase = "https://#{evernoteHost}/edam/note/"

    noteStoreUrl = noteStoreUrlBase + access_token.params[:edam_shard]
    noteStoreTransport = Thrift::HTTPClientTransport.new(noteStoreUrl)
    noteStoreProtocol = Thrift::BinaryProtocol.new(noteStoreTransport)
    noteStore = Evernote::EDAM::NoteStore::NoteStore::Client.new(noteStoreProtocol)

    notebooks = noteStore.listNotebooks(access_token.token)

    notebooks.each do |notebook|
      filter = Evernote::EDAM::NoteStore::NoteFilter.new
      filter.notebookGuid = notebook.guid
      limit = 1000
      offset  =0
      note_list = noteStore.findNotes access_token.token, filter, offset, limit 



      note_list.notes.each do |note|
        p noteStore.getNote access_token.token, note.guid, true, true, true, true
        p 887788778877887788778877887788778877
        p note.title
        p 99999999999999999999999999999999999
        WikiPage.create(
          :creator_id => current_user.id, 
          :product_id => params[:product_id], 
          :title => note.title,
          :content => note.content
        )
      end
    end

    # UserEvernoteAuth.create(:user_id => current_user.id, :access_token => access_token)

  end



end
