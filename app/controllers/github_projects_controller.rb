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


  def show
    @last_sha, @first_sha = '', ''
    @last_sha = "?last_sha=" + params['last_sha'] if params['last_sha']
    @first_sha = "?first_sha=" + params['first_sha'] if params['first_sha']


    @commits = GithubApiMethods.get_github_project(@github_project.url, @last_sha + @first_sha)
    @commits_by_time = @commits.group_by {|commit| commit['commit']['author']['date'][0..9] }


    # 用于判断下一页
    api_uri = GithubApiMethods.get_api_uri(@github_project.url, 'commits')
    @next_sha = "?last_sha=#{@commits[@commits.length - 1]['sha']}"
    @next_commits = GithubApiMethods.http_connection(api_uri, @next_sha)
  end

  def next_page
  end

  def prev_page
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
