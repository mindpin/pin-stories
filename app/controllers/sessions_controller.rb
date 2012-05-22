class SessionsController < ApplicationController
  include SessionsMethods
  include SessionsControllerMethods

  layout 'simple_form', :only=>[:new]
end
