class ModelAttachesController < ApplicationController
  before_filter :login_required

  def destroy
    @attach = ModelAttach.find(params[:id])
    @attach.destroy
    redirect_to :back
  end
end