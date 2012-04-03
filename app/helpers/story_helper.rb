module StoryHelper
  
  def admin_logged_in?
    logged_in? && current_user.is_admin?
  end
  
end