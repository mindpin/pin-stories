class HttpApisController < ApplicationController
  def designer
  end

  def create
    http_api = current_user.http_apis.build(params[:http_api])
    http_api.save
  end

  def new
  end
end
