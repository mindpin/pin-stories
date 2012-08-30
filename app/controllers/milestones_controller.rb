class MilestonesController < ApplicationController
  before_filter :login_required
  before_filter :pre_load

  def pre_load
    @product = Product.find(params[:product_id]) if params[:product_id]
    @milestone = Milestone.find(params[:id]) if params[:id]
  end

  def index
    @milestones = @product.milestones
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

end
