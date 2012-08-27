class MilestoneReportsController < ApplicationController
  before_filter :login_required
  before_filter :pre_load

  def pre_load
    @milestone = Milestone.find(params[:milestone_id]) if params[:milestone_id]
    @report = MilestoneReport.find(params[:id]) if params[:id]
  end

  def show
    @milestone = Milestone.find(@report.milestone_id)
  end

  def new
  end

  def create
    params[:milestone_report][:creator_id] = current_user.id
    report = @milestone.reports.create(params[:milestone_report])

    redirect_to "/milestone_reports/#{report.id}"
  end


  def edit
  end

  def update
    @report.update_attributes(params[:milestone_report])
    redirect_to "/milestones/#{@report.milestone_id}"
  end

  def destroy
    @report.close
    redirect_to "/milestones/#{@report.milestone_id}"
  end


  def create_issue
    current_user.milestone_issues.create(params[:milestone_issue])

    redirect_to :back
  end
end
