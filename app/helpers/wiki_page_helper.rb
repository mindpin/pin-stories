module WikiPageHelper
  # 获取一个wiki_page版本记录的正文内容
  def get_wiki_audit_content(audit)
    audit.revision.content
  end
end