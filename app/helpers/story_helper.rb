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

  def issue_ct(issue)
    html_escape(issue.content).gsub(/\n/, '<br />').html_safe
  end


  # 获取一个 story 版本记录的 how_to_demo
  def get_story_audit_how_to_demo(audit)
    audit.revision.how_to_demo
  end


  # 获取一个 story 版本记录的 tips
  def get_story_audit_tips(audit)
    audit.revision.tips
  end

  # 判断该 story 是否有被 wiki 引用
  def has_referenced_by_wiki?(story)
    WikiPage.where(:from_model_id => story.id, :from_model_type => 'Story').exists?
  end

  # 取得引用当前 story 的  wiki title
  def referenced_title_by_wiki(story)
    WikiPage.where(:from_model_id => story.id, :from_model_type => 'Story').first.title
  end

  def story_link(story)
    link_to "story #{story.id}", "/stories/#{story.id}"
  end

  def issue_link(issue)
    link_to "issue #{issue.id}", "/issues/#{issue.id}"
  end

  def wiki_page_link(wiki_page)
    link_to "wiki #{truncate_u(wiki_page.title, 12)}", "/products/#{wiki_page.product.id}/wiki/#{wiki_page.title}"
  end

end