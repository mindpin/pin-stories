class MembersController < ApplicationController
  
  # 所有TEAM成员
  def index
    @members = User.all
  end
  
  def show
    @member = User.find(params[:id], :include=>[:member_info])
  end
  
end