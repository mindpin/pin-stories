require 'spec_helper'

describe UserCommentTipMessage do

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

  it '可以生成 hash_name' do
    comment_tip = UserCommentTipMessage.new(@ben7th)
    base_tip = UserTipMessage.new(@ben7th)

    comment_tip.hash_name.should_not == base_tip.hash_name
  end

  describe '创建和删除评论的相关测试' do
    it '创建评论时会生成消息提示' do
      @issue.valid?.should == true

      comment_1 = Comment.create(
        :creator => @kaid,
        :model => @issue,
        :content => '2了'
      )
      comment_1.new_record?.should_not == true
      @ben7th.comment_tip_message.count.should == 1

      11.times do
        comment = Comment.create(
          :creator => @kaid,
          :model => @issue,
          :content => '2了'
        )
      end

      @ben7th.comment_tip_message.count.should == 12

      comment_1.destroy
      @ben7th.comment_tip_message.count.should == 11

      @issue.comments.first.destroy
      @ben7th.comment_tip_message.count.should == 10
    end

    it '用户给自己创建的评论不会进入提示' do
      @issue.creator.should == @ben7th

      comment = Comment.create(
        :creator => @ben7th,
        :model => @issue,
        :content => '2了'
      )

      @ben7th.comment_tip_message.count.should == 0
    end

    it '回复其他人的评论时会创建提示' do
      @issue.creator.should == @ben7th

      comment_1 = Comment.create(
        :creator => @kaid,
        :model => @issue,
        :content => '2了'
      )

      Comment.create(
        :creator => @ben7th,
        :model => @issue,
        :content => '我要回复你呀',
        :reply_comment => comment_1
      )


      @ben7th.comment_tip_message.count.should == 1
      @kaid.comment_tip_message.count.should == 1
    end

    it '回复自己的评论时不会创建提示' do
      @issue.creator.should == @ben7th

      comment_1 = Comment.create(
        :creator => @kaid,
        :model => @issue,
        :content => '2了'
      )

      Comment.create(
        :creator => @kaid,
        :model => @issue,
        :content => '我要回复你呀',
        :reply_comment => comment_1
      )


      @ben7th.comment_tip_message.count.should == 2
      @kaid.comment_tip_message.count.should == 0
    end

  end

end