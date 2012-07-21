class IssuesController < ApplicationController

  before_filter :login_required
  before_filter :pre_load

  def pre_load
    @product = Product.find(params[:product_id]) if params[:product_id] 
  end

  def index
    @issues = Issue.where(:product_id => @product.id).paginate(:page => params[:page], :per_page => 20).order('id DESC')
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

  def update
    id = params[:id]
    content = params[:content]

    unless id.nil?
      issue = Issue.find(id) 
      issue.content = content
      issue.save
    end

    render :text => issue.content
  end

  def destroy
    id = params[:id]
    unless id.nil?
      issue = Issue.find(id) 
      issue.destroy
    end

    render :nothing => true
  end

end