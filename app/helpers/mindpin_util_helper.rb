module MindpinUtilHelper
  def self.included(base)
    base.send(:include, LayoutMethods)
    base.send(:include, FlashInfoMethods)
    base.send(:include, AvatarMethods)
    base.send(:include, UserSignMethods)
    base.send(:include, FormDomsMethods)
  end

  module LayoutMethods
    
    # 给当前页面设置标题
    def htitle(str)
      content_for :title do
        str
      end
    end

    # 在 layout 的 :topbar 区域生成面包屑导航
    def hbreadcrumb(str, url, options = {})
      content_for :breadcrumb do
        content_tag :div, :class => 'link' do
          content_tag(:a, str, :href => url)
        end
      end
    end

  end

  module FlashInfoMethods
    # 回显校验信息
    def flash_info
      re = []
      [:notice, :error, :success].each do |kind|
        msg = flash[kind]
        re << "<div class='flash-info #{kind}'><span>#{msg}</span></div>" if !msg.blank?
      end
      raw re * ''
    end
  end

  module AvatarMethods
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

  module UserSignMethods
    def user_link(user)
      return '未知用户' if user.blank?
      link_to user.name, "/members/#{user.id}", :class=>'u-name'
    end
  end

  module FormDomsMethods
    def jcheckbox(name, value, checked, text)
      span_klass = checked ? 'c checked' : 'c'

      content_tag :div, :class => 'pie-j-checkbox' do
        re1 = content_tag :span, :class => span_klass do
          check_box_tag(name, value, checked)
        end

        re2 = link_to(text.html_safe, 'javascript:;', :class => 'text')

        re1 + re2
      end
    end

    def jsearchbar(url, options = {})
      placeholder = options[:placeholder] || '搜索…'
      default_value = options[:default] || ''

      # %form.page-search-bar{:action=>url, :method=>'get', :'data-enter-to-submit'=>true}
      #   .field.placeholder.need
      #     %label 输入搜索内容
      #     %input{:name=>'query', :type=>'text', :value => query || ''}
      #     %a.go{:href=>'javascript:;'} 搜索

      form_tag url, :method=>:get, :class=>'page-search-bar', :'data-enter-to-submit'=>true do
        content_tag :div, :class=>'field placeholder need' do
          content_tag(:label, placeholder) +
          text_field_tag(:query, default_value) +
          link_to('搜索', 'javascript:;', :class=>'go')
        end
      end
    end
  end
end