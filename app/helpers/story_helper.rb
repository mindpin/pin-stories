module StoryHelper
  
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
  
  def status_to_str(status_name)
    return {
      Story::STATUS_NOT_ASSIGN => :未开始,
      Story::STATUS_DOING => :正在做,
      Story::STATUS_REVIEWING => :Review,
      Story::STATUS_DONE => :已完成,
      Story::STATUS_PAUSE => :暂缓
    }[status_name]
  end
  
  def format_ct(story, field)
    html_escape(story[field]).gsub(/\n/, '<br />').html_safe
  end
  
end