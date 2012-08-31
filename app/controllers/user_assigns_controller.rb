# -*- coding: utf-8 -*-
class UserAssignsController < ApplicationController
  before_filter :login_required
  
  def new
    klass = params[:model_type].constantize
    @model = klass.find params[:model_id]
  end

  def create
    klass = params[:model_type].constantize
    model = klass.find params[:model_id]

    model.assigned_user_ids = params[:user_ids]
    model.save

    redirect_to model
  end

  def assign_to_me
    klass = params[:model_type].constantize
    model = klass.find params[:model_id]

    model.assigned_users << current_user

    render :text => '成功分配'
  rescue Exception => ex
    render :status => 403,
           :text => '分配失败'
  end
end
