class WikiPageRecommander

  def self._split(text)
    algor = RMMSeg::Algorithm.new(text)
    
    words = []
    loop do
      tok = algor.next_token
      break if tok.nil?
      words << tok.text
    end
    words
  end

  def self.recommand_by_content(product, content)
    words = _split(content)
    words = words.sort{|a, b| b[1] <=> a[1]}
    search_str = words[0..2].map{|data| data}.join(' | ')

    p "以 '#{search_str}' 发起搜索"

    # 搜索
    return WikiPage.search(search_str, 
      :conditions => {:product_id => product.id}
    )
  end

end