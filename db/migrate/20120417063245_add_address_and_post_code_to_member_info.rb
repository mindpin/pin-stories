class AddAddressAndPostCodeToMemberInfo < ActiveRecord::Migration
  def change
    add_column(:member_infos, :address, :string)    #地址
    add_column(:member_infos, :post_code, :string)  #邮编
  end
end
