class IndexController < ApplicationController
  def index
    # return render :template=>'index/index' if logged_in?
    
    # 如果还没有登录，渲染登录页
    # return render :template=>'index/login'
  end

  def create_agile_issue
    # 快速为 agile 产品 创建bug
    product_agile = Product.find(1)
    issue = product_agile.issues.build
    issue.content = params[:content]
    issue.creator = current_user

    if issue.save
      return render :json => issue
    end

    render :status => 401,
           :text => '创建失败'
  end
end
