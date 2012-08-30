# -*- coding: utf-8 -*-
class UsecasesController < ApplicationController
  before_filter :login_required
  before_filter :pre_load

  def pre_load
    @milestone = Milestone.find(params[:milestone_id]) if params[:milestone_id]
    @usecase = Usecase.find(params[:id]) if params[:id]
  end

  def new
  end

  def create
    usecase = current_user.usecases.build(params[:usecase])
    #usecase = current_user.usecases.build(:content => params[:content], :usecase_id => params[:usecase_id])
    usecase.product = @milestone.product
    usecase.milestone = @milestone

    if usecase.save
      return render :text => '用例创建成功!'
    end

    render :status => 406, :text => usecase.errors.messages.to_json
  end


  def edit
  end


  def update
    @usecase.update_attributes(params[:usecase])
    redirect_to "/milestones/#{@usecase.milestone_id}"
  end

  def destroy
    url = @usecase.milestone
    @usecase.destroy
    redirect_to url
  end
end
