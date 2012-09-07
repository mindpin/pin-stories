class WikiPageFormatter

  TITLE_REGEXP              = /^[A-Za-z0-9一-龥\-\s\!]+$/
  TITLE_INVALID_CHAR_REGEXP = /[^A-Za-z0-9一-龥\-\s\!]+/
  TITLE_REF_REGEXP          = /\[\[([A-Za-z0-9一-龥\-\s\!]+)\]\]/
  ATME_REGEXP               = /@([A-Za-z0-9一-龥]+)/

  class NoProductError < Exception; end;

  attr_accessor :wiki_page, :raw_text, :filtered_elms_hash

  def initialize(wiki_page)
    raise NoProductError if wiki_page.product.blank?
    self.wiki_page = wiki_page
    self.raw_text  = wiki_page.content || ''
  end

  def format
    coderay_render = _build_coderay_render
    markdown = _build_markdown(coderay_render)

    formatted_content = markdown.render(_mindpin_filter_text)
    toc = coderay_render.get_toc # 顺序必须写在上一句后面

    re = _push_filtered_hash_into "#{toc}#{formatted_content}"

    return re.html_safe
  end

  # 分段编辑时，切分出需要的段落文字
  # TODO 这段还是有些繁琐，可能还需要进一步简化
  # 2012.7.25 当程序段内出现标题语法时，这种情况没有排除
  def split_section(section_num)
    # 生成 lines 对象链表结构
    lines = ContentLine._build_lines_linked_list(self.wiki_page)

    # 挑选出所有标题文字所在行
    header_lines = lines.select{|line| line.is_header?}

    # 找到 section_num 对应起始行
    start_line = header_lines[section_num - 1]

    start_line_num = start_line.line_num
    end_line_num   = lines.last.line_num

    # 找 end_line
    header_lines[section_num .. -1].each do |header_line|
      if header_line.header_level <= start_line.header_level
        end_line_num = header_line.line_num - 1
        break
      end
    end

    # -----------

    return lines[start_line_num..end_line_num].map{|line| line.text}
  end

  # 分段编辑时，将指定的新内容替换到指定的section里
  def replace_section(section_num, new_content)
    # 生成 lines 对象链表结构
    lines = ContentLine._build_lines_linked_list(self.wiki_page)

    # 挑选出所有标题文字所在行
    header_lines = lines.select{|line| line.is_header?}

    # 找到 section_num 对应起始行
    start_line = header_lines[section_num - 1]

    start_line_num = start_line.line_num
    end_line_num   = lines.last.line_num

    # 找 end_line
    header_lines[section_num..-1].each do |header_line|
      if header_line.header_level <= start_line.header_level
        end_line_num = header_line.line_num - 1
        break
      end
    end

    if(0 == start_line_num)
      part2 = [new_content, "\n"]
      part3 = lines[(end_line_num + 1) .. -1 ].map{|line| line.text}

      return (part2 + part3)*''
    else
      part1 = lines[0 .. (start_line_num - 1)].map{|line| line.text}
      part2 = [new_content, "\n"]
      part3 = lines[(end_line_num + 1) .. -1 ].map{|line| line.text}
      

      return (part1 + part2 + part3)*''
    end
  end

  private

    def _build_coderay_render
      HTMLwithCoderay.new(self.wiki_page,
        :filter_html     => true, # 滤掉自定义html
        :safe_links_only => true, # 只允许安全连接
        :hard_wrap       => true, # 单回车换行
        :with_toc_data   => true
      )
    end

    def _build_markdown(coderay_render)
      Redcarpet::Markdown.new(coderay_render,
        :no_intra_emphasis   => true,
        :fenced_code_blocks  => true,
        :autolink            => true,
        :strikethrough       => true,
        :space_after_headers => true
      )
    end

    def _push_filtered_hash_into(text)
      self.filtered_elms_hash.each do |key, value|
        text = text.gsub key, value
      end
      text
    end

    def _mindpin_filter_text
      self.filtered_elms_hash = {}

      text_0 = _filter_atme(self.raw_text)
      text_1 = _filter_ref(text_0)
    end

    # 过滤 @某某 语法
    def _filter_atme(text)
      re = ''
      text.each_line do |line_text|
        re += line_text.gsub ATME_REGEXP do
          key = "^#{randstr}^"
          value = "<a href='/atme/#{$1}' class='page-at-user'>@#{$1}</a>"
          self.filtered_elms_hash[key] = value
          key
        end
      end
      re
    end

    #  过滤 [[]] 双方括弧语法
    def _filter_ref(text)
      re = ''
      text.each_line do |line_text|
        re += line_text.gsub TITLE_REF_REGEXP do
          key = "^#{randstr}^"

          title = $1
          product = self.wiki_page.product
          exists = !product.wiki_pages.find_by_title(title).blank?
          klass = exists ? 'page-wiki-page-ref' : 'page-wiki-page-ref no-page'

          value = "<a href='/products/#{product.id}/wiki/#{title}' class='#{klass}'>#{title}</a>"
          self.filtered_elms_hash[key] = value
          key
        end
      end
      re
    end

  # --------

  class ContentLine
    attr_accessor :text, :next_line, :prev_line, :section_num, :line_num, :is_in_code_block

    REGEXP_TYPE_ONE = /^(\#{1,6})\s+(.+)/

    REGEXP_TYPE_TWO_A = /^\=+\s*$/
    REGEXP_TYPE_TWO_B = /^\-+\s*$/

    REGEXP_CODE_START_A = /^~~~(.*)$/
    REGEXP_CODE_START_B = /^---(.*)$/

    REGEXP_CODE_END_A = /^~~~\s*$/
    REGEXP_CODE_END_B = /^---\s*$/

    def self._build_lines_linked_list(wikipage)
      re = []

      last_line = ContentLine.new(nil, nil)
      is_in_code_block = false
      code_status = nil

      wikipage.content.lines.each_with_index do |text, index|

        if (is_in_code_block == false)
          if text.match REGEXP_CODE_START_A
            is_in_code_block = true
            code_status = :A
          elsif text.match REGEXP_CODE_START_B
            is_in_code_block = true
            code_status = :B
          end
        elsif (is_in_code_block == true)
          if (code_status == :A) && (text.match REGEXP_CODE_END_A)
            is_in_code_block = false
            code_status = nil
          elsif (code_status == :B) && (text.match REGEXP_CODE_END_B)
            is_in_code_block = false
            code_status = nil
          end
        end

        line = ContentLine.new(text, index)
        line.is_in_code_block = is_in_code_block

        last_line.next_line = line
        line.prev_line = last_line
        last_line = line
        
        re << line
      end

      return re
    end

    def initialize(text, line_num)
      self.text     = text
      self.line_num = line_num
    end

    def is_header?
      return false if self.is_in_code_block

      return true if self._is_match_header_type_one?
      return true if self._is_match_header_type_two?
      return false
    end

    def _is_match_header_type_one?
      match_data = self.text.match REGEXP_TYPE_ONE
      if match_data
        @header_level = match_data[1].length
        return true
      end
      return false
    end

    def _is_match_header_type_two?
      return false if self.next_line.nil?

      str = self.next_line.text

      if str.match REGEXP_TYPE_TWO_A
        @header_level = 1
        return true
      end

      if str.match REGEXP_TYPE_TWO_B
        @header_level = 2
        return true
      end

      return false
    end

    def header_level
      return -1 if !self.is_header?
      return @header_level
    end
  end

  # --------

  class HTMLwithCoderay < Redcarpet::Render::HTML

    # 用于处理内文标题渲染，以及目录构建的小类
    class HeaderRender

      class Header
        attr_reader :text, :level, :order_num, :wikipage, :children
        attr_accessor :parent, :index_num, :text_repeat_count

        def initialize(text, level, order_num, wikipage)
          @text      = text
          @level     = level
          @order_num = order_num
          @wikipage  = wikipage

          @children  = []
        end

        def add(header)
          last_child = self.children.last

          if last_child.nil? || last_child.level >= header.level
            self.children << header
            header.parent = self
            header.index_num = self.children.length
          else
            last_child.add(header)
          end

          return header
        end

        def to_html
          tag = "h#{self.level}"

          span_text = "<span id='#{self.html_id}'>#{text}</span>"
          span_edit = "<span class='edit-section'>[<a href='#{self.edit_link}'>编辑</a>]</span>"

          return "<#{tag}>#{span_text}</#{tag}>" if @wikipage.preview
          return "<#{tag}>#{span_text} #{span_edit}</#{tag}>"
        end

        def to_toc_li_html
          re = @children.map { |header| header.to_toc_li_html }
          ul_children = re.blank? ? '' : "<ul>#{re}</ul>"

          span_text = "<span class='text'>#{self.text}</span>"
          span_list_num = "<span class='list-number'>#{self.list_number}</span>"

          a = "<a href='##{self.html_id}'>#{span_list_num} #{span_text}</a>"

          return "<li>#{a} #{ul_children}</li>"
        end

        def html_id
          uri_encode = URI.encode(self.text).gsub('%', '.')

          self.text_repeat_count <= 1 ? uri_encode : "#{uri_encode}_#{self.text_repeat_count}"
        end

        def edit_link
          wikipage = self.wikipage
          "/products/#{wikipage.product_id}/wiki/#{wikipage.title}/edit_section?section=#{self.order_num}"
        end

        def list_number
          self.parent.nil? ? self.index_num : "#{parent.list_number}.#{self.index_num}"
        end

      end

      # ---------------

      def initialize(wiki_page)
        @wiki_page = wiki_page

        @children       = []
        @next_order_num = 1
        @repeat_count_hash = Hash.new(0)
      end

      def add(text, header_level)
        header = Header.new(text, header_level, @next_order_num, @wiki_page)
        @next_order_num += 1
        @repeat_count_hash[text] += 1
        header.text_repeat_count = @repeat_count_hash[text]

        last_child = @children.last

        if last_child.nil? || last_child.level >= header.level
          @children << header
          header.index_num = @children.length
        else
          last_child.add(header)
        end


        return header
      end

      def to_toc_ul_html
        re = @children.map { |header| header.to_toc_li_html }
        return "<ul>#{re}</ul>"
      end
    end

    attr_accessor :wiki_page, :product, :header_render

    # 每次渲染正文前必须调用该函数，给一些实例变量赋值
    def initialize(wiki_page, *params)
      self.wiki_page = wiki_page
      self.product   = wiki_page.product
      self.header_render = HeaderRender.new(self.wiki_page)

      super(*params)
    end

    # ---------------

    def block_code(code, language)
      # 代码格式化选项参考
      # http://coderay.rubychan.de/doc/classes/CodeRay/Encoders/HTML.html

      CodeRay.scan(code, language).div(
        :tab_width    => 2,
        :css          => :class,
        :line_numbers => :inline,
        :line_number_anchors => false,
        :bold_every   => false
      )
    end

    # 通过定义该方法，能够控制所有 header 的渲染样式
    def header(text, header_level)
      t = text.strip
      if !t.blank?
        @header_render.add(text.strip, header_level).to_html
      end
    end

    def paragraph(text)
      re = text.gsub("\n", '<br/>').gsub(' ', '&nbsp;')
      return "<p>#{re}</p>"
    end

    def get_toc
      ul_html = @header_render.to_toc_ul_html
      ul_html == '<ul></ul>' ? '' : "<div class='table-of-contents'>#{ul_html}</div>"
    end

    # TODO 这里还可以做更多扩展
    # TODO 参考这个： 
    #   http://dev.af83.com/2012/02/27/howto-extend-the-redcarpet2-markdown-lib.html
    #   "How to extend the Redcarpet 2 Markdown library?"
  end

end