module WikiPageHelper

  # 获取一个wiki_page版本记录的正文内容
  def get_wiki_audit_content(audit)
    audit.revision.content
  end

  def has_referenced_from_story?(wiki_page)
  	WikiPage.where(:from_model_id => wiki_page.from_model_id, :from_model_type => wiki_page.from_model_type).exists?
  end

end