class WikiController < ApplicationController

  before_filter :pre_load
  def pre_load
    @product = Product.find(params[:product_id]) if params[:product_id]
    @wiki_page = @product.wiki_pages.find_by_title(params[:title]) if params[:title]
  end

  def index
    @wiki_pages = @product.wiki_pages
  end
  
  def show
  end

  def new
    @wiki_page = WikiPage.new
    render :layout=>'simple_form'
  end
  
  def create
    @wiki_page = current_user.wiki_pages.build(params[:wiki_page])
    @wiki_page.product = @product

    if @wiki_page.save
      redirect_to URI.encode("/products/#{@wiki_page.product_id}/wiki/#{@wiki_page.title}")
      return
    end

    flash[:error] = @wiki_page.errors.first
    return render :new, :layout=>'simple_form'
  end
  
  # 预览
  def preview
    title = params[:title]
    content = params[:content]

    if title.blank? || content.blank?
      render :nothing => true
    else
      wiki_page = current_user.wiki_pages.build({:title => title, :content => content})

      filename = Time.now.to_i
      source_file = File.join($SPHINX_SPILT_WORDS_TEMPFILE_PATH, "source_#{filename}")
      target_file = File.join($SPHINX_SPILT_WORDS_TEMPFILE_PATH, "target_#{filename}")

      File.open(source_file, 'w') {|f| f.write(content) }

      # 生成分词文件
      IO.popen("/usr/local/mmseg3/bin/mmseg -d /usr/local/mmseg3/etc #{source_file} >> #{target_file}"){ |f| puts f.gets }
      
      # 读取分词文件内容
      target_content = IO.read(target_file)
      target_content = target_content.gsub(/[^A-Za-z0-9一-龥]+\/x/, '')
      File.open(target_file, 'w') {|f| f.write(target_content) }

      # 把分词文件内容转为数组
      target_data = target_content.split(/\/x/).inject(Hash.new(0)) { |h,v| h[v] += 1; h }

      # 排序
      sorted_target_data = target_data.sort{|a,b| b[1] <=> a[1]}

      # 取得最多出现的头三个词
      top_target_data = sorted_target_data[0..2]

      top1 = top_target_data[0][0].gsub(/(\W|\d)/, "") unless top_target_data[0].nil?
      top2 = top_target_data[1][0].gsub(/(\W|\d)/, "") unless top_target_data[1].nil?
      top3 = top_target_data[2][0].gsub(/(\W|\d)/, "") unless top_target_data[2].nil?


      # 搜索
      search_result = WikiPage.search("#{top1} | #{top2} | #{top3}", 
        :conditions => {:product_id => @product.id}
      )

      @title = params[:title]
      @content = wiki_page.formatted_content
      @relative_search = search_result

      render :layout => false
    end

    

=begin
    @wiki = {:title => params[:title], :content => wiki_page.formatted_content, 
            :relative_search => search_result}


    respond_to do |format|
      format.html
      format.json{
        render :text => wiki.to_json
      }
    end
=end

  end

  def edit
    render :layout=>'simple_form'
  end
  
  def update
    @wiki_page.update_attributes(params[:wiki_page])
    redirect_to URI.encode("/products/#{@wiki_page.product_id}/wiki/#{@wiki_page.title}")
  end
  
  def versions
    @audits = @wiki_page.audits.descending 
    # 参考audited源代码
    # https://github.com/collectiveidea/audited/blob/master/lib/audited/adapters/active_record/audit.rb
    # 23 行，通过这个scope使其按version反序排列
    # 此处还有一些scope会比较有用
  end
  
  # 所有记录的版本回滚
  def rollback
    audit = @wiki_page.audits.find_by_version(params[:version])
    @wiki_page.rollback_to(audit)
    
    redirect_to URI.encode("/products/#{@wiki_page.product_id}/wiki/#{@wiki_page.title}")
  end

  def destroy
    @wiki_page.destroy
    redirect_to "/products/#{@wiki_page.product_id}/wiki"
  end
  
  # ------------------------

  # 编辑内容区块页面
  def edit_section
    section_number = params[:section].to_i
    @content = WikiPageFormatter.split_section(@wiki_page, section_number)
  end

  def update_section
    section_number = params[:section].to_i

    @wiki_page.content = WikiPageFormatter.replace_section(@wiki_page, section_number, params[:content])
    @wiki_page.save

    redirect_to URI.encode("/products/#{@wiki_page.product_id}/wiki/#{@wiki_page.title}")
  end

  # 当前页面引用页
  def refs
    # 当前引用的
    @refs = WikiPageRef.where(:product_id => params[:product_id], :from_page_title => params[:title])

    # 引用当前的
    @used_refs = WikiPageRef.where(:product_id => params[:product_id], :to_page_title => params[:title])

  end

  # 没有被其他wiki页引用，也没有引用其他wiki页的页面
  def orphan
    wiki_pages = WikiPage.all

    @orphan_pages = []
    wiki_pages.each do |wiki_page|
      from = WikiPageRef.where(:product_id => wiki_page.product_id, :from_page_title => wiki_page.title).exists?
      to = WikiPageRef.where(:product_id => wiki_page.product_id, :to_page_title => wiki_page.title).exists?

      unless from || to
        @orphan_pages << wiki_page
      end

    end
  end

  # 全文索引，搜索
  def search
    @keyword = params[:keyword]
    @search_result = WikiPage.search(@keyword, 
      :conditions => {:product_id => @product.id}, 
      :page => params[:page], :per_page => 20)
  end

end
