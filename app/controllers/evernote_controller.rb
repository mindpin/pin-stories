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
    @notebooks = EvernoteData.get_notebooks_of(current_user)
    @tags = EvernoteData.get_tags_of(current_user)
  end

  def confirm_import
    notebook_guids = params[:import_all_notebooks] || params[:notebook_guids]
    tag_guids      = params[:import_all_tags] || params[:tag_guids]

    @found_notes = EvernoteData.get_selected_notes(current_user, notebook_guids, tag_guids)
  end

  # 尝试导入一条笔记
  def do_import
    repeat_deal = params[:repeat_deal]
    note_guid = params[:guid]
    note_title = params[:title]

    if('drop' == repeat_deal)
      if WikiPage.find_by_title(note_title).blank?
        wiki_page = WikiPage.new
        wiki_page.title = note_title
        wiki_page.content = EvernoteData.get_note_content_by_guid(current_user, note_guid)
        wiki_page.creator = current_user
        wiki_page.product = @product
        wiki_page.save!
      end
    end

    if('replace' == repeat_deal)
      wiki_page = WikiPage.find_by_title(note_title) || WikiPage.new
      wiki_page.content = EvernoteData.get_note_content_by_guid(current_user, note_guid)
      wiki_page.save!
    end

    render :text=>'ok'
  rescue Exception=>ex
    p ex
    render :status=>500, :text=>ex
  end

end