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

    redirect_to "/milestones"
  end

  def show 
  end

  def edit
  end

  def update
    @milestone.update_attributes(params[:milestone])

    redirect_to "/milestones"
  end

  def destroy
    @milestone.destroy

    redirect_to "/milestones"
  end
end
