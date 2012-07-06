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
=begin
    filename = Time.now.to_i

    source_file = File.join($SPHINX_SPILT_WORDS_TEMPFILE_PATH, "source_#{filename}")
    target_file = File.join($SPHINX_SPILT_WORDS_TEMPFILE_PATH, "target_#{filename}")

    File.open(source_file, 'w') {|f| f.write(content) }


    # 生成磁盘文件，调用shell命令进行分词
    IO.popen("/usr/local/mmseg3/bin/mmseg -d /usr/local/mmseg3/etc #{source_file} >> #{target_file}"){ |f| puts f.gets }
    
    # 读取分词后的文件内容
    file_content = IO.read(target_file)

    # 滤掉文件最后一行的  'Word Splite took: 0 ms.' 信息
    # 滤掉所有换行符
    # 滤掉所有非中英文的符号
    filtered_content = file_content.lines.to_a[0..-3].join('')
    filtered_content = filtered_content.gsub(/\n/, '')
    filtered_content = filtered_content.gsub(/[^A-Za-z0-9一-龥]+\/x/, '')

    # 把分词文件内容转为计数hash
    target_data = filtered_content.split('/x ').inject(Hash.new(0)) { |hash, key| hash[key.strip] += 1; hash }

    # 排序
    sorted_target_data = target_data.sort{|a, b| b[1] <=> a[1]}

    # 取得最多出现的头三个词，组成搜索关键词
    search_str = sorted_target_data[0..2].map{|data| data[0]}.join(' | ')
=end
    # RMMSeg::Dictionary.load_dictionaries

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