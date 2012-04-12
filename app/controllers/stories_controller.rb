class StoriesController < ApplicationController
  before_filter :login_required
  before_filter :pre_load
  def pre_load
    @product = Product.find(params[:product_id]) if params[:product_id] 
    @story = Story.find(params[:id]) if params[:id]
  end
  
  def new
    @story = Story.new
  end
  
  def create
    @story = Story.new(params[:story])
    @story.product = @product
    
    if @story.save
      return redirect_to "/stories/#{@story.id}"
    end

    flash[:error] = get_flash_error(@story)
    redirect_to "/products/#{@product.id}/stories/new"
  end
  
  def edit
  end

  def update
    if @story.update_attributes(params[:story])
      redirect_to @story, :notice => '故事信息被修改了'
    else
      render :text=>@story.errors.to_json
    end
  end
  
  
  def assign_streams
  end
  
  def do_assign_streams
    streams = (params[:stream_ids]||[]).map{|sid|Stream.find_by_id(sid)}.compact
    if streams.blank?
      flash[:error] = "最少指定一个 Stream"
      return redirect_to "/stories/#{@story.id}/assign_streams"
    end
    @story.streams = streams
    redirect_to "/stories/#{@story.id}"
  end
  
  def assign_users
  end
  
  def do_assign_users
    users = (params[:user_ids]||[]).map{|uid|User.find_by_id(uid)}.compact
    if users.blank?
      flash[:error] = "至少指派给一个人"
      return redirect_to "/stories/#{@story.id}/assign_users"
    end
    @story.users = users
    redirect_to "/stories/#{@story.id}"
  end
  
  def change_status
    status = params[:status].upcase
    @story.change_status(status)
    redirect_to "/stories/#{@story.id}"
  end
  
  def mine
    @stories = current_user.stories
  end
end
