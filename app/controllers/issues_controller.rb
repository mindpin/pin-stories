class IssuesController < ApplicationController

  before_filter :login_required
  before_filter :pre_load

  def pre_load
    @product = Product.find(params[:product_id]) if params[:product_id]
    @issue = Issue.find(params[:id]) if params[:id]
  end

  def index
    c = @product.issues.with_state(Issue::STATE_OPEN)
    @issues = c.paginate(:page => params[:page], :per_page => 20).order('id DESC')
  end

  def index_closed
    c = @product.issues.with_state(Issue::STATE_CLOSED)
    @issues = c.paginate(:page => params[:page], :per_page => 20).order('id DESC')
    render :index
  end

  def index_pause
    c = @product.issues.with_state(Issue::STATE_PAUSE)
    @issues = c.paginate(:page => params[:page], :per_page => 20).order('id DESC')
    render :index
  end

  def new
    @issue = Issue.new
  end

  def edit
  end

  def create    
    issue = Issue.new params[:issue]
    issue.creator = current_user
    issue.product = @product

    if issue.save
      return redirect_to "/products/#{@product.id}/issues"
    end

    flash[:error] = issue.errors.to_json
    redirect_to [:new, @product, :issue]
  end

  def show
    @product = @issue.product
  end

  def update
    @issue.update_attributes(params[:issue])
    redirect_to "/issues/#{@issue.id}"
  end

  # for ajax
  def destroy
    current_user.issues.find(params[:id]).destroy
    render :nothing => true
  end

  # for ajax
  def reopen
    @issue.state = Issue::STATE_OPEN
    @issue.save

    render :partial => 'issues/parts/show', 
           :locals => {:issue => @issue}
  end

  # for ajax
  def close
    @issue.state = Issue::STATE_CLOSED
    @issue.save

    render :partial => 'issues/parts/show', 
           :locals => {:issue => @issue}
  end


  # for ajax
  def pause
    @issue.state = Issue::STATE_PAUSE
    @issue.save

    render :partial => 'issues/parts/show', 
           :locals => {:issue => @issue}
  end



  def assign_users
  end
  
  def do_assign_users
    users = (params[:user_ids]||[]).map{|uid|User.find_by_id(uid)}.compact
    if users.blank?
      flash[:error] = "至少指派给一个人"
      return redirect_to "/issues/#{@issue.id}/assign_users"
    end
    @issue.users = users
    redirect_to "/issues/#{@issue.id}"
  end

end