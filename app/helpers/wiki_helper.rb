module WikiHelper


  # def coderay(text)
  #   text.gsub!(/\<code(?: lang="(.+?)")?\>(.+?)\<\/code\>/m) do
  #     lang  = 'ruby'
  #     lines = $2

  #     code = CodeRay.scan(lines, lang).div(:css => :class)
  #     ## "<notextile>#{code}</notextile>" 
  #     code
  #   end
  #   # return text.html_safe.gsub(/#39;/, '"').gsub(/&amp;/, '').gsub(/quot;/, "'")
  #   return text
  # end

  # def test_markdown(text)
  #   options = {   
  #       :autolink => true, 
  #       :space_after_headers => true,
  #       :fenced_code_blocks => true,
  #       :no_intra_emphasis => true,
  #       :hard_wrap => true,
  #       :strikethrough =>true
  #     }
  #   markdown = Redcarpet::Markdown.new(HTMLwithCodeRay, options)
  #   markdown.render(text).html_safe
  # end

  # class HTMLwithCodeRay < Redcarpet::Render::HTML
  #   def block_code(code, language)
  #     CodeRay.scan(code, language.to_sym).div(:tab_width=>2)
  #   end
  # end


end
