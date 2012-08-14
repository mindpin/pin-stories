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
end
