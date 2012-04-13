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
      return "#{name} #{klass}" if path == '/' || path.start_with?('/products')
    when :members
      return "#{name} #{klass}" if path.start_with? '/members'
    when :admin
      return "#{name} #{klass}" if path.start_with? '/admin'
    when :mine
      return "#{name} #{klass}" if path.start_with? '/mine'
    end
    
    return name
  end
  
  def status_label(story)
    status = story.status
    
    str = {
      Story::STATUS_NOT_ASSIGN => :未开始,
      Story::STATUS_DOING => :正在做,
      Story::STATUS_REVIEWING => :Review,
      Story::STATUS_DONE => :已完成,
      Story::STATUS_PAUSE => :暂缓
    }[story.status]
    
    return content_tag(:div, str, :class=>"page-story-status-label #{status.downcase}")
  end
  
end