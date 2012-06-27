module MindpinUtilHelper
  
  # 给当前页面设置标题
  def htitle(str)
    content_for :title do
      str
    end
  end
  
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

end