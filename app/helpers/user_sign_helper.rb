module UserSignHelper
  
  def userlink(user)
    return '未知用户' if user.blank?
    link_to user.name, "/members/#{user.id}", :class=>'u-name'
  end
  
end
