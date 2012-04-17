class AddMobilePhoneAndCardInfosToMemberInfo < ActiveRecord::Migration
  def change
    add_column(:member_infos, :phone_number, :string)     #手机号
    add_column(:member_infos, :bank_card_number, :string) #银行卡号
    add_column(:member_infos, :deposit_bank, :string)     #开户行
  end
end