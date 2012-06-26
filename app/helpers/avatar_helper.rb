module AvatarHelper
  # 用户头像helper
  
  def avatar(user, style = :normal)
    klass = ['avatar-img', style]*' '

    if user.blank?
      alt   = '未知用户'
      src   = User.new.logo.url(style)
      meta  = 'unknown-user'
    else
      alt   = user.name
      src   = user.logo.url(style)
      meta  = dom_id(user)
    end
    
    image_tag(src, :alt=>alt, :class=>klass, :'data-meta'=>meta)
  end
  
  def avatar_link(user, style = :normal)
    href  = user.blank? ? 'javascript:;' : "/members/#{user.id}"
    title = user.blank? ? '未知用户' : user.name
    
    link_to href, :title=>title do
      avatar(user, style)
    end
  end
end
