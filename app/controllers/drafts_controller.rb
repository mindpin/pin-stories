class DraftsController < ApplicationController
  def index
    @my_drafts = Draft.where(:creator_id => current_user.id).paginate(:page => params[:page], :per_page => 20).order('id DESC')
  end
end
