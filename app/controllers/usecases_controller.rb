class UsecasesController < ApplicationController
  before_filter :login_required
  before_filter :pre_load

  def pre_load
    @milestone = Milestone.find(params[:milestone_id]) if params[:milestone_id]
  end

  def new
  end

  def create

    params[:usecase][:product_id] = @milestone.product_id
    params[:usecase][:milestone_id] = @milestone.id
    params[:usecase][:usecase_id] = 0 if params[:usecase][:usecase_id].blank?

    usecase = current_user.usecases.build(params[:usecase])
    usecase.save

    redirect_to "/milestones/#{@milestone.id}"
  end
end