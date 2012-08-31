module MindpinUtilHelper
  def self.included(base)
    base.send(:include, LayoutMethods)
    base.send(:include, FlashInfoMethods)
    base.send(:include, AvatarMethods)
    base.send(:include, UserSignMethods)
    base.send(:include, FormDomsMethods)
    base.send(:include, ImageMethods)
    base.send(:include, TimeMethods)
    base.send(:include, CommentMethods)
  end

  module LayoutMethods
    
    # 给当前页面设置标题
    def htitle(str)
      content_for :title do
        str
      end
    end

    # 在 layout 的 :topbar 区域生成面包屑导航
    def hbreadcrumb(str, url = nil, options = {})
      url ||= 'javascript:;'

      content_for :breadcrumb do
        content_tag :div, :class => 'link' do
          content_tag(:a, truncate_u(str, 16), :href => url)
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
      klass = ['page-avatar-img', style]*' '

      if user.blank?
        alt   = '未知用户'
        src   = User.new.logo.url(style)
        meta  = 'unknown-user'
      else
        alt   = user.name
        src   = user.logo.url(style)
        meta  = dom_id(user)
      end
      
      # jimage src, :alt => alt, 
      #             :class => klass, 
      #             :'data-meta' => meta

      image_tag src, :alt => alt, 
                     :class => klass, 
                     :'data-meta' => meta
    end
  
    def avatar_link(user, style = :normal)
      href  = user.blank? ? 'javascript:;' : "/users/#{user.id}"
      title = user.blank? ? '未知用户' : user.name
      
      link_to href, :title=>title do
        avatar(user, style)
      end
    end
  end

  module UserSignMethods
    def user_link(user)
      return '未知用户' if user.blank?
      link_to user.name, "/users/#{user.id}", :class=>'u-name'
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

    # 表单里的提交按钮
    def jfsubmit(text)
      # %a.form-submit-button{:href=>'javascript:;'} 登录
      content_tag :a, text, :href => 'javascript:;',
                            :class => 'form-submit-button'
    end

    def jfcancel(text)
      # %a.form-cancel-button{:href=>'javascript:history.go(-1);'} 返回
      content_tag :a, text, :href => 'javascript:history.go(-1);',
                            :class => 'form-cancel-button'
    end

    def jdelete(text, href, confirm_text)
      content_tag :a, text, :href => 'javascript:;',
                            :class => 'page-jdelete',
                            :'data-jconfirm' => confirm_text,
                            :'data-jhref' => href
    end
  end

  module ImageMethods
    def jimage(src, options = {})
      alt = options[:alt] || ''

      width = options[:width] || nil
      height = options[:height] || nil
      
      if !width.nil? && !height.nil?
        style = "width:#{width}px;height:#{height}px;"
      else
        style = ''
      end

      klass = options[:class] || ''
      klass = [klass, 'auto-fit-image'] * ' '

      content_tag :div, '', 
                  :class => klass, 
                  :style => style,
                  :'data-src' => src, 
                  :'data-alt' => alt, 
                  :'data-meta' => options[:'data-meta']
    end
  end

  module TimeMethods
    # TIME TZ
    def time_tz(time)
      time.strftime("%Y-%m-%dT%H:%M:%SZ")
    end
    
    def jtime(time)
      return content_tag(:span, '未知', :class=>'date') if time.blank?
      
      local_time = time.localtime
      content_tag(:span, _friendly_relative_time(local_time), :class=>'date', :'data-date'=>local_time.to_i)
    end

    private
      # 根据当前时间与time的间隔距离，返回时间的显示格式
      # 李飞编写
      def _friendly_relative_time(time)
        current_time = Time.now
        seconds = (current_time - time).to_i
        
        return '片刻前' if seconds < 0
        return "#{seconds}秒前" if seconds < 60        
        return "#{seconds/60}分钟前" if seconds < 3600
        return time.strftime('%H:%M') if seconds < 86400 && current_time.day == time.day
        return time.strftime("#{time.month}月#{time.day}日 %H:%M") if current_time.year == time.year
        return time.strftime("%Y年#{time.month}月#{time.day}日 %H:%M")
      end
  end

  module CommentMethods
    def comment_ct(comment)
      html_escape(comment.content).gsub(/\n/, '<br />').html_safe
    end

    def jcomments(model)
      render 'aj/comments', :model => model
    end
  end
end