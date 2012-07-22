class UsersController < ApplicationController
  
  # 所有TEAM成员
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id], :include=>[:member_info])
  end
  
end