class GithubProjectsController < ApplicationController
  before_filter :login_required
  before_filter :pre_load

  def pre_load
    @product = Product.find(params[:product_id]) if params[:product_id] 
    @github_project = GithubProject.find(params[:id]) if params[:id]
  end

  def index
    @github_projects = GithubProject.paginate(:page => params[:page], :per_page => 20)
  end
  
  def new
  end

  def edit
  end

  def update
    @github_project.update_attributes(params[:github_project])
    return redirect_to "/products/#{@github_project.product_id}/github_projects"
  end


  def create
    if @product.github_projects.create(params[:github_project])
      return redirect_to "/products/#{@product.id}/github_projects"
    end

    flash[:error] = @github_project.errors.to_json
    redirect_to "/products/#{@product.id}/github_projects/new#"
  end

  def destroy
    @github_project.destroy
    return redirect_to "/products/#{@github_project.product_id}/github_projects"
  end
end
