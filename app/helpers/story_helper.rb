module StoryHelper
  
  # 回显校验信息
  # TODO rails3 下，需要重写
  def flash_info
    re = []
    [:notice, :error, :success].each do |kind|
      msg = flash[kind]
      re << "<div class='flash-#{kind}'><span>#{msg}</span></div>" if !msg.blank?
    end
    raw re*''
  end
  
  # 是否管理员登录？
  def admin_logged_in?
    logged_in? && current_user.is_admin?
  end
  
  # 用于顶部导航栏
  def nav_current_klass(name)
    
    klass = :current
    path = request.path
    
    case name.to_sym
    when :products
      return "#{name} #{klass}" if path == '/'
    when :members
      return "#{name} #{klass}" if path.start_with? '/members'
    when :admin
      return "#{name} #{klass}" if path.start_with? '/admin'
    end
    
    return name
  end
  
end