class IssuesController < ApplicationController

  before_filter :login_required
  before_filter :pre_load

  def pre_load
    @product = Product.find(params[:product_id]) if params[:product_id] 
  end

  def index
    @product_issues = @product.issues
  end

  def new
    @issue = Issue.new
  end

  def create    
    issue = Issue.new params[:issue]
    issue.creator = current_user
    issue.product = @product

    if issue.save
      return redirect_to "/products/#{@product.id}/issues"
    end

    flash[:error] = issue.errors.to_json
    redirect_to [:new, @product, :issue]
  end

end