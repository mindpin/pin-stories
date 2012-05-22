class WikiPageVersion
  attr_reader :audit
  def initialize(audit)
    @audit = audit
  end

  def creator
    @audit.user
  end

  def wiki_page
    @audit.auditable
  end

  def version
    @audit.version
  end

  def title
    case @audit.action
    when "create"
      @audit.audited_changes["title"]
    when "update"
      title_hash = @audit.audited_changes["title"]

      return title_hash[1] if !title_hash.blank?
      prev.title
    when "destroy"
      @audit.audited_changes["title"]
    end
  end

  def content
    case @audit.action
    when "create"
      @audit.audited_changes["content"]
    when "update"
      content_hash = @audit.audited_changes["content"]

      return content_hash[1] if !content_hash.blank?
      prev.content
    when "destroy"
      @audit.audited_changes["content"]
    end
  end        

  def prev
    WikiPageVersion.new(prev_audit)
  end

  def prev_audit
    Audited::Adapters::ActiveRecord::Audit.where(:auditable_id=>@audit.auditable_id,:version=>@audit.version-1).first
  end
end