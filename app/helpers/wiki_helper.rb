module WikiHelper


  def coderay(text) 
    text.gsub!(/\<code(?: lang="(.+?)")?\>(.+?)\<\/code\>/m) do 
      code = CodeRay.scan($2, $1).div(:css => :class) 
      "<notextile>#{code}</notextile>" 
    end
    # return text.html_safe.gsub(/#39;/, '"').gsub(/&amp;/, '').gsub(/quot;/, "'")
    return text.html_safe
  end

=begin

  def markdown(text)
    options = {   
        :autolink => true, 
        :space_after_headers => true,
        :fenced_code_blocks => true,
        :no_intra_emphasis => true,
        :hard_wrap => true,
        :strikethrough =>true
      }
    markdown = Redcarpet::Markdown.new(HTMLwithCodeRay,options)
    markdown.render(h(text)).html_safe
  end

  class HTMLwithCodeRay < Redcarpet::Render::HTML
    def block_code(code, language)
      CodeRay.scan(code, language).div(:tab_width=>2)
    end
  end
=end


end
