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

  def show
    @comments = @story.comments
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
    # param_status = params[:story_status]
    # @filtered_stories = param_status.blank? ? @mine_stories : @mine_stories.with_status(param_status)
    
    hash = {}

    current_user.assigned_stories.each do |story|
      product = story.product
      if hash.keys.include? product
        hash[product] << story
      else
        hash[product] = [story]
      end
    end

    @mine_products_hash = hash

  end


  # 全文索引，搜索当前产品下所有story
  def search
    @keyword = params[:keyword]
    @search_result = Story.search(@keyword, 
      :conditions => {:product_id => @product.id}, 
      :page => params[:page], :per_page => 20)
  end

  # 全文索引，搜索属于我的story
  def search_mine
    @keyword = params[:keyword]
    stories = Story.search(@keyword)
    
    @search_result = []
    current_user.assigned_stories.each do |my_story|

      stories.each_with_index do |item, index|
        if my_story.id == item.id
          @search_result << item
        end
      end

    end

  end


  def versions
    @audits = @story.audits.descending
  end
  
  # 所有记录的版本回滚
  def rollback
    audit = @story.audits.find_by_version(params[:version])
    @story.rollback_to(audit)
    
    redirect_to "/stories/#{@story.id}"
  end


end
