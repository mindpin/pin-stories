class WikiPageRecommander

  STOP_WORDS = begin
    arr = []
    file = File.new File.expand_path('../stopwords.txt', __FILE__)
    file.read.split("\r\n")
  end

  def self._split(_text)
    text = _text || '' 
    # 防止进程崩溃！
    # 如果对 RMMSeg::Algorithm.new 传入 nil
    # 会导致 Segmentation fault
    # 而使得进程崩溃

    algor = RMMSeg::Algorithm.new(text)
    
    words = []
    loop do
      tok = algor.next_token
      break if tok.nil?

      word = tok.text
      words << word if !STOP_WORDS.include?(word)
    end
    words
  end

  def self.recommand_by_content(product, content)
    return [] if content.blank?

    words = _split(content)
    
    # 统计词频
    hash = Hash.new(0)
    words.each do |word|
      hash[word] += 1
    end

    # 根据词频排序
    top_words = hash.to_a.sort {|a, b| b[1] <=> a[1]}

    top_3_words = top_words[0..2].map{|data| data[0]}

    search_str = top_3_words.join(' | ')

    p content
    p top_3_words
    p "以 '#{search_str}' 发起搜索"

    # 搜索
    return WikiPage.search(search_str, 
      :conditions => {:product_id => product.id}
    )
  end

end