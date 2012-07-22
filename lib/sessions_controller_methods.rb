module SessionsControllerMethods
  # 登录
  def new
    return redirect_back_or_default(root_url) if logged_in?
    return render :template=>'index/login'
  end
  
  def create
    self.current_user = User.authenticate(params[:email], params[:password])
    return _create_android if is_android_client?
    _create_web
  end
  
  # 登出
  def destroy
    user = current_user
    
    if user
      reset_session_with_online_key()
      # 登出时销毁cookies令牌
      destroy_remember_me_cookie_token()
      destroy_online_record(user)
    end
    
    return redirect_to '/'
  end
  
  private
  def _create_android
    if logged_in?
      after_logged_in()
      return render :json=>{:user=>current_user.api0_json_hash}
    else
      return render :status=>401, :text=>'登录失败，用户名 / 密码错误'
    end
  end
  
  def _create_web
    if logged_in?
      after_logged_in()
      redirect_back_or_default("/")
    else
      flash[:error] = '登录失败，用户名 / 密码错误'
      redirect_to '/login'
    end
  end
  
end
