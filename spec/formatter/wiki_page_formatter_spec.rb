require 'spec_helper'

describe WikiPageFormatter do

  before do
    @ben7th = User.create(
      :name  => 'ben7th',
      :email => 'ben7th@sina.com',
      :password => '123456'
    )

    @product = Product.create!(
      :name => 'TEAMKN',
      :description => '团队知识小工具',
      :cover => File.new(File.join(Rails.root, 'app/assets/images/site.logo.png'))
    )

    @wiki_page = @product.wiki_pages.create!(
      :title => 'UI基本规范',
      :content => 'hehe',
      :creator => @ben7th
    )

    @wiki_page_more_section = @product.wiki_pages.create!(
      :title => 'UI基本规范',
      :content => "## 标题一\n## 标题二\n## 标题三",
      :creator => @ben7th
    )
  end

  it '能够格式化双方括弧语法' do
    wiki_page = @product.wiki_pages.create!(
      :title => '基本测试页',
      :content => '[[UI基本规范]]',
      :creator => @ben7th
    )

    wiki_page.formatted_content.should == 
     "<p><a href='/products/#{@product.id}/wiki/UI基本规范' class='page-wiki-page-ref'>UI基本规范</a></p>"
  end

  it '能够格式化包含空格的双方括弧语法' do
    title = '我的名字里有 空格'

    @product.wiki_pages.create!(
      :title => title,
      :content => 'blahblah',
      :creator => @ben7th
    )

    wiki_page = @product.wiki_pages.create!(
      :title => '我来引用你',
      :content => "h[[#{title}]]ooo",
      :creator => @ben7th
    )

    wiki_page.formatted_content.should == 
     "<p>h<a href='/products/#{@product.id}/wiki/#{title}' class='page-wiki-page-ref'>#{title}</a>ooo</p>"
  end

  it '能够以实例方法的形式被调用' do
    formatter = WikiPageFormatter.new(@wiki_page)
    formatter.format.should_not == nil
    formatter.format.should == '<p>hehe</p>'
  end

  describe '分段编辑逻辑测试' do
    it '能够调用分段方法' do
      formatter = WikiPageFormatter.new(@wiki_page_more_section)

      formatter.split_section(2).should_not == nil
      formatter.replace_section(2, 'good idea').should_not == nil
    end

    pending '段落切分测试'
    pending '段落替换测试'
  end
end