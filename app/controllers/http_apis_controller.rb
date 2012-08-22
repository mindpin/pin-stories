class HttpApisController < ApplicationController
  def designer
    @http_apis = HttpApi.all
  end

  def create
    http_api = current_user.http_apis.build(params[:http_api])
    redirect_to "/http_apis/designer" if http_api.save

    error = http_api.errors.first
    flash[:error] = "#{error[0]} #{error[1]}"
    render :action => :new
  end

  def new
  end

  def edit
    @http_api = HttpApi.find(params[:id])
  end

  def update
    @http_api = HttpApi.find(params[:id])
    @http_api.update_attributes(params[:http_api])

    redirect_to "/http_apis/designer"
  end

  def destroy
    http_api = HttpApi.find(params[:id])
    http_api.destroy if http_api.creator == current_user

    redirect_to "/http_apis/designer"
  end

end
