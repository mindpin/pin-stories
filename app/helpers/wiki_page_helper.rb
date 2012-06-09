module WikiPageHelper

  # 获取一个wiki_page版本记录的正文内容
  def get_wiki_audit_content(audit)
    case audit.action
    when 'create'
      return audit.audited_changes['content']
    when 'update'
      return audit.audited_changes['content'].last
    end
  end

end