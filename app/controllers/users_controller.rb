class UsersController < ApplicationController
  before_filter :pre_load
  def pre_load
    @user = User.find(params[:id]) if params[:id]
  end

  # 所有TEAM成员
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id], :include=>[:member_info])
  end

  def issues
  end

  def assigned_issues
  end

  def ideas
  end
  
end