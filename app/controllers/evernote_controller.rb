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
    # EvernoteData.import(current_user, product_id, access_token, shard, notebook_name, tag_names)

  end

end