module WikiPageHelper
  # 获取一个wiki_page版本记录的正文内容
  def get_wiki_audit_content(audit)
    audit.revision.content
  end

  def ref_link(product, title)
    url = "/products/#{product.id}/wiki/#{title}/"

    exists = !product.wiki_pages.find_by_title(title).blank?
    klass = exists ? 'page-wiki-page-ref' : 'page-wiki-page-ref no-page'

    link_to title, url, :target => "_blank", :class => klass
  end
end