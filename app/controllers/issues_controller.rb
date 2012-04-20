class IssuesController < ApplicationController

  before_filter :login_required

  def new
    @product = Product.find(params[:product_id])
    @issue = Issue.new
  end

  def create
    product = Product.find(params[:product_id])
    
    issue = Issue.new params[:issue]
    issue.creator = current_user
    issue.product = product

    if issue.save
      return redirect_to "/products/#{product.id}/issues"
    end

    flash[:error] = issue.errors.to_json
    redirect_to [:new, product, :issue]
  end

end