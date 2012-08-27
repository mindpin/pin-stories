class MilestonesController < ApplicationController
  before_filter :login_required
  before_filter :pre_load

  def pre_load
    @milestone = Milestone.find(params[:id]) if params[:id]
  end

  def index
    @milestones = Milestone.all
  end

  def new
    @milestone = Milestone.new
  end

  def create
    @milestone = current_user.milestones.build(params[:milestone])
    @milestone.save

    redirect_to "/products/#{@milestone.product_id}/milestones"
  end

  def show 
  end

  def edit
  end

  def update
    @milestone.update_attributes(params[:milestone])

    redirect_to "/products/#{@milestone.product_id}/milestones"
  end

  def destroy
    @milestone.destroy

    redirect_to "/products/#{@milestone.product_id}/milestones"
  end

  def create_usecase
    @usecase = current_user.usecases.build(params[:usecase])
    @usecase.save

    redirect_to :back
  end

  def create_report
    @milestone.reports.create(:creator => current_user)

    redirect_to :back
  end


end
