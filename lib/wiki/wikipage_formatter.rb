class WikipageFormatter

  def self.format(wikipage)
    coderay_render = HTMLwithCoderay.new(
      :filter_html     => true, # 滤掉自定义html
      :safe_links_only => true, # 只允许安全连接
      :hard_wrap       => true  # 单回车换行
    )
    coderay_render.wikipage = wikipage

    markdown = Redcarpet::Markdown.new(coderay_render,
      :no_intra_emphasis   => true,
      :fenced_code_blocks  => true,
      :autolink            => true,
      :strikethrough       => true,
      :space_after_headers => true
    )

    formatted_content = markdown.render(wikipage.content)
    toc = coderay_render.get_toc # 顺序必须写在上一句后面

    return "#{toc}#{formatted_content}".html_safe
  end

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

      def initialize(wikipage)
        @wikipage = wikipage

        @children       = []
        @next_order_num = 1
        @repeat_count_hash = Hash.new(0)
      end

      def add(text, header_level)
        header = Header.new(text, header_level, @next_order_num, @wikipage)
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

    # 每次渲染正文前必须调用该函数，给一些实例变量赋值
    def wikipage=(wikipage)
      @wikipage = wikipage
      @product_id = @wikipage.product_id

      @header_render = HeaderRender.new(@wikipage)
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
      @header_render.add(text, header_level).to_html
    end

    def paragraph(text)
      re = text.gsub("\n", '<br/>')
      
      re = _trans_atme(re)
      re = _trans_ref(re)

      return "<p>#{re}</p>"
    end

    def get_toc
      return "<div class='table-of-contents'>#{@header_render.to_toc_ul_html}</div>"
    end


    private

      # 转换 @某某 语法
      def _trans_atme(text)
        text.gsub(/@([A-Za-z0-9一-龥]+)/, '<a href="/atme/\1">@\1</a>')
      end

      #  转换 [[]] 语法
      def _trans_ref(text)
        text.gsub /\[\[([A-Za-z0-9一-龥]+)\]\]/ do
          # 滤去 & ? _ 三个特殊字符，转换成 -
          #title = $1.gsub /[?&_]+/, '-'
          title = $1

          "<a href='/products/#{@product_id}/wiki/#{title}'>#{title}</a>"
        end
      end

    # TODO 这里还可以做更多扩展
    # TODO 参考这个： http://dev.af83.com/2012/02/27/howto-extend-the-redcarpet2-markdown-lib.html
    # "How to extend the Redcarpet 2 Markdown library?"
  end

end