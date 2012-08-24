class MilestoneReportsController < ApplicationController

  def show
    report_id = params[:id]

    @report = MilestoneReport.find(report_id)
    @milestone = Milestone.find(@report.milestone_id)
  end

  def create_issue
    current_user.milestone_issues.create(params[:milestone_issue])

    redirect_to :back
  end
end
