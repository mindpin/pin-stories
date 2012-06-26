class EvernoteController < ApplicationController

  before_filter :login_required
  before_filter :pre_load
  def pre_load
    @product = Product.find(params[:product_id]) if params[:product_id]
  end

  # 连接 evernote
  def connect
    callback_url = request.url.chomp('connect').concat('callback')
    session[:request_token] = EvernoteData.get_request_token(callback_url)

    redirect_to session[:request_token].authorize_url
  end

  def callback
    access_token = session[:request_token].get_access_token(:oauth_verifier=> params['oauth_verifier'])

    # 将 access_token 存入数据库
    evernote_auth = current_user.evernote_auth || UserEvernoteAuth.new(:user=>current_user)
    evernote_auth.access_token = Marshal.dump(access_token)
    evernote_auth.save

    redirect_to "/products/#{@product.id}/wiki_evernote_import"
  end

  def import
  end

  def confirm_import
    has_all_notebooks = params[:has_all_notebooks]
    has_all_tags = params[:has_all_tags]

    notebook_names = []
    tag_names =[]
    if has_all_notebooks == 'true'
      notebooks = EvernoteData.get_notebooks_of(current_user)
      notebooks.each do |notebook|
        notebook_names << notebook.name
      end
    else
      notebook_names = params[:notebook_names]
    end

    if has_all_tags == 'true'
      tags = EvernoteData.get_tags_of(current_user)
      tags.each do |tag|
        tag_names << tag.name
      end
    else
      tag_names = params[:tag_names]
    end

    @confirmed_notebooks = EvernoteData.get_confirmed_notebooks(current_user, @product, notebook_names, tag_names)
  end

  def do_import
    override_list = params[:override_list]
    override_dump_notebooks = params[:override_dump_notebooks]
    not_repeat_notebooks = params[:not_repeat_notebooks]

    # 处理需要覆盖的
    unless override_list.nil?
      override_list.each do |title, request_action|
        if request_action == 'true'
          wiki_page = WikiPage.where(:title => title).first
          wiki_page.content = override_dump_notebooks[title]
          wiki_page.save
        end
      end
    end

    # 处理不重复的
    unless not_repeat_notebooks.nil?
      not_repeat_notebooks.each do |title, content|
        WikiPage.create(
          :creator => current_user, 
          :product => @product, 
          :title => title,
          :content => content
        )
      end
    end

    # render :action => 'test'
    redirect_to "/products/#{@product.id}/wiki"
  end

end