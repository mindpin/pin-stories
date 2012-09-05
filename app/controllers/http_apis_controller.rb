class HttpApisController < ApplicationController
  before_filter :login_required
  before_filter :pre_load

  def pre_load
    @http_api = HttpApi.find(params[:id]) if params[:id]
  end


  def index
    @http_apis = HttpApi.paginate(:page => params[:page], :per_page => 20)
  end


  def show
  end

  def create
    http_api = current_user.http_apis.build(params[:http_api])
    if http_api.save
      return redirect_to '/http_apis'
    end

    flash[:error] = http_api.errors.to_json
    render :new
  end

  def new
  end

  def edit
  end

  def update
    @http_api.http_api_params.each {|http_api_param| http_api_param.destroy }
    @http_api.update_attributes(params[:http_api])

    redirect_to '/http_apis'
  end

  def destroy
    @http_api.destroy if @http_api.creator == current_user
    redirect_to '/http_apis'
  end

end
