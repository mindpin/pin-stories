# -*- coding: utf-8 -*-
class UserAssignsController < ApplicationController
  before_filter :login_required
  
  def new
  end

  def create
    assign = current_user.assigns.create params[:assign]
    return redirect_to :action => :new if assign.invalid?
    redirect_to assign.model
  end

  def assign_to_me
    assign = current_user.assigns.create :model_id   => params[:model_id],
                                         :model_type => params[:model_type]

    return render :status => 406,
                  :json => assign.errors.messages if assign.invalid?

    render :text => '成功分配'
  end
end
