class Admin::AdminController < ApplicationController
  
  before_filter :check_admin_logged_in
  def check_admin_logged_in
    if !(logged_in? && current_user.is_admin?)
      return render :text=>'访问此功能需要管理员权限'
    end
  end

  before_filter :pre_load
  def pre_load
    @member = User.find(params[:id]) if !params[:id].blank?
    @member.find_or_create_info if !@member.blank?
  end
  
  def members
  end

  def new_member
    @member = User.new
  end

  def create_member
    @member = User.new(params[:user])
    if @member.save
      return redirect_to '/admin/members'
    end
    
    flash[:error] = get_flash_error(@member)
    redirect_to '/admin/members/new'
  end
  
  def edit_member
  end
  
  def update_member
    if @member.update_attributes(params[:user])
      return redirect_to '/admin/members'
    end
    
    flash[:error] = @member.errors.to_json
    redirect_to "/admin/members/#{@member.id}/edit"
  end
  
end