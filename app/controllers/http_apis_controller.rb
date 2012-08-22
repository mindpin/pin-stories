class HttpApisController < ApplicationController
  before_filter :login_required
  before_filter :pre_load

  def pre_load
    @http_api = HttpApi.find(params[:id]) if params[:id]
  end


  def designer
    @http_apis = HttpApi.paginate(:page => params[:page], :per_page => 20)
  end

  def create
    http_api = current_user.http_apis.build(params[:http_api])
    if http_api.save
      redirect_to "/http_apis/designer"
    else
      flash[:error] = "error"
    end
  end

  def new
  end

  def edit
  end

  def update
    @http_api.http_api_params.each {|http_api_param| http_api_param.destroy }
    @http_api.update_attributes(params[:http_api])

    redirect_to "/http_apis/designer"
  end

  def destroy
    @http_api.destroy if @http_api.creator == current_user

    redirect_to "/http_apis/designer"
  end

end
