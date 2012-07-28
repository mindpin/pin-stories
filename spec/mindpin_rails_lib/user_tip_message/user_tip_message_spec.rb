require 'spec_helper'

describe UserTipMessage do

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
  end

  it '能够创建消息' do
    tip = UserTipMessage.new(@ben7th)
    key = randstr
    tip.put(key, '测试消息')
    tip.count.should == 1
  end

  it '能够统计消息条数' do
    tip_ben7th = UserTipMessage.new(@ben7th)
    tip_kaid   = UserTipMessage.new(@kaid)

    10.times do
      tip_ben7th.put(randstr)
    end

    21.times do
      tip_kaid.put(randstr)
    end

    tip_ben7th.count.should == 10
    tip_kaid.count.should == 21
  end

  it '能够获取到所有消息，且不同人取到的消息不会互相影响' do
    messages_ben7th = {}
    messages_kaid   = {}

    10.times do
      messages_ben7th[randstr] = randstr
    end

    12.times do
      messages_kaid[randstr] = randstr
    end

    tip_ben7th = UserTipMessage.new(@ben7th)
    messages_ben7th.each do |key, msg|
      tip_ben7th.put(msg, key)
    end

    tip_kaid = UserTipMessage.new(@kaid)
    messages_kaid.each do |key, msg|
      tip_kaid.put(msg, key)
    end

    tip_ben7th.all.should == messages_ben7th
    tip_kaid.all.should == messages_kaid
  end

  it '能够清空所有消息' do
    messages = []
    10.times do
      messages << randstr
    end

    tip_ben7th = UserTipMessage.new(@ben7th)

    messages.each do |msg|
      tip_ben7th.put(msg)
    end

    tip_ben7th.count.should_not == 0
    tip_ben7th.clear
    tip_ben7th.count.should == 0
  end

  it '能够删除单条消息' do
    tip_ben7th = UserTipMessage.new(@ben7th)
    key = randstr

    tip_ben7th.put('哈哈哈哈', key)
    tip_ben7th.count.should == 1

    tip_ben7th.delete(key)
    tip_ben7th.count.should == 0
  end

end