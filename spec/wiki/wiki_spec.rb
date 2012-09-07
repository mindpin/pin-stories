require 'spec_helper'

describe WikiPage do
  let(:ben7th) {FactoryGirl.create :user}
  let(:product_agile) {FactoryGirl.create :product}

  describe '标题会在创建和编辑时被正确的格式化' do
    it '会替换掉不允许的字符, 只允许 中英文/数字/横线/空格/叹号 并且会过滤掉多余的连续空格和首尾空格' do
      WikiPage.count.should == 0

      count = 0
      [
        ['test', 'test'],
        ['我是中文', '我是中文'],
        ['xiao ', 'xiao'],
        ['xiao!', 'xiao!'],
        ['x!i?ao?', 'x!i-ao-'],
        ['ben7th@sina.com', 'ben7th-sina-com'],
        ['敏捷开发?     是软件工程方法!', '敏捷开发- 是软件工程方法!'],
      ].each do |arr|
        title, result = arr[0], arr[1]

        count += 1

        WikiPage.create :creator => ben7th,
                        :product => product_agile,
                        :title => title

        WikiPage.count.should == count
        WikiPage.first.title.should == result
      end
    end

    pending '会在重复标题上增加时间戳'
  end
end