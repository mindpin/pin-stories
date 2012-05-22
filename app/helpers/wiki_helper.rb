module WikiHelper
  def coderay(text) 
    text.gsub!(/\<code(?: lang="(.+?)")?\>(.+?)\<\/code\>/m) do 
      CodeRay.scan($2, $1).div(:css => :class) 
    end 
    return text.html_safe 
  end
end
