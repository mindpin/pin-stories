class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  helper :all
  
  def is_android_client?
    request.headers['User-Agent'] == 'android'
  end
end