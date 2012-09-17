class WorkResultsController < ApplicationController
  def index
    @work_results = WorkResult.paginate(:page => params[:page], :per_page => 6)
  end

  def new
  end

  def create
    @work_result = current_user.work_results.build( params[:work_result] )
    @work_result.save

    redirect_to "/work_results"
  end


  def next
  	@work_results = WorkResult.paginate(:page => params[:page], :per_page => 6)

  	render :action => 'index'
  end


  def show
    @work_result = WorkResult.find(params[:id])

    # 创建新的查看记录
    @work_result.create_view_record(current_user)
  end

end
