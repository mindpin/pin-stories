require 'spec_helper'

describe Comment do

  before do
    UserTipMessage.instance.keys.each do |key|
      UserTipMessage.instance.del key
    end
    
    @ben7th = User.create(
      :name  => 'ben7th',
      :email => 'ben7th@sina.com',
      :password => '123456'
    )

    @kaid = User.create(
      :name  => 'kaid',
      :email => 'kaid@sina.com',
      :password => '123456'
    )

    @lifei = User.create(
      :name  => 'lifei',
      :email => 'lifei@sina.com',
      :password => '123456'
    )

    @product = Product.create!(
      :name => 'TEAMKN',
      :description => '团队知识小工具',
      :cover => File.new(File.join(Rails.root, 'app/assets/images/site.logo.png')),
      :kind => Product::KIND_SERVICE
    )

    @issue = Issue.create(
      :creator => @ben7th,
      :content => 'ahahahah',
      :product => @product
    )
  end

  it '可以为用户创建评论，并获取评论' do
    @issue.add_comment(@kaid, '我来评论一下')

    @ben7th.received_comments.count.should == 1
    @kaid.send_comments.count.should == 1
  end

  it '多次评论和回复评论后，每个人能正确地获取到给自己的评论列表和自己发出的评论列表' do
    @issue.creator.should == @ben7th

    comment_1 = Comment.create  :creator => @kaid,
                                :model => @issue,
                                :content => '关关雎鸠'

    @ben7th.received_comments.count.should == 1
    @ben7th.send_comments.count.should == 0

    @kaid.received_comments.count.should == 0
    @kaid.send_comments.count.should == 1

    @lifei.received_comments.count.should == 0
    @lifei.send_comments.count.should == 0

    comment_2 = Comment.create :creator => @lifei,
                               :model => @issue,
                               :content => '在河之洲',
                               :reply_comment => comment_1

    @ben7th.received_comments.count.should == 2
    @ben7th.send_comments.count.should == 0

    @kaid.received_comments.count.should == 1
    @kaid.send_comments.count.should == 1

    @lifei.received_comments.count.should == 0
    @lifei.send_comments.count.should == 1

    comment_3 = Comment.create :creator => @ben7th,
                               :model => @issue,
                               :content => '窈窕淑女',
                               :reply_comment => comment_2

    @ben7th.received_comments.count.should == 2
    @ben7th.send_comments.count.should == 1

    @kaid.received_comments.count.should == 1
    @kaid.send_comments.count.should == 1

    @lifei.received_comments.count.should == 1
    @lifei.send_comments.count.should == 1

    comment_4 = Comment.create :creator => @lifei,
                               :model => @issue,
                               :content => '君子好逑',
                               :reply_comment => comment_3

    @ben7th.received_comments.count.should == 3
    @ben7th.send_comments.count.should == 1

    @kaid.received_comments.count.should == 1
    @kaid.send_comments.count.should == 1

    @lifei.received_comments.count.should == 1
    @lifei.send_comments.count.should == 2
  end

end