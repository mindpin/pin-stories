class MilestoneIssuesController < ApplicationController
  before_filter :login_required
  before_filter :pre_load

  def pre_load
    @milestone_issue = MilestoneIssue.find(params[:id]) if params[:id]
  end

  def update
    @milestone_issue.update_attributes(params[:milestone_issue])
    redirect_to :back
  end

  def destroy
    @milestone_issue.destroy
    redirect_to :back
  end

  def change_state
    @milestone_issue.update_attributes(:state => params[:state])
    render :partial => '/milestone_issues/aj/show_state', :locals => {:milestone_issue => @milestone_issue}
  end
end
