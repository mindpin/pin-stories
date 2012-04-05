class Admin::AdminController < ApplicationController
  
  before_filter :check_admin_logged_in
  def check_admin_logged_in
    if !(logged_in? && current_user.is_admin?)
      return render :text=>'访问此功能需要管理员权限'
    end
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
    @member = User.find(params[:id])
  end
  
  def update_member
    @member = User.find(params[:id])
    
    @member.email = params[:user][:email] if !params[:user][:email].blank?
    @member.name  = params[:user][:name]  if !params[:user][:name].blank?
    @member.logo  = params[:user][:logo]  if !params[:user][:logo].blank?
    
    info = @member.find_or_create_info
    info.real_name = params[:real_name] if !params[:real_name].blank?
    
    if @member.save && info.save
      return redirect_to '/admin/members'
    end
    
    flash[:error] = @member.errors.to_json
    redirect_to "/admin/members/#{@member.id}/edit"
  end
  
end