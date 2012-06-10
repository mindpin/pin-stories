class AtmeController < ApplicationController

  # 用于跳转到个人首页
  def atme
    user = User.find_by_name(params[:name])

    if user.nil?
      render :text=>'用户不存在', :status=>404 
    else
      redirect_to "/members/#{user.id}"
    end
  end

end