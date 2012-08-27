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
    usecase.product = @milestone.product
    usecase.milestone = @milestone

    if usecase.save
      return redirect_to @milestone
    end

    render :text=>usecase.errors.to_json
  end


  def edit
  end


  def update
    @usecase.update_attributes(params[:usecase])
    redirect_to "/milestones/#{@usecase.milestone_id}"
  end

  def destory
    @usecase.destroy
    redirect_to @milestone
  end
end