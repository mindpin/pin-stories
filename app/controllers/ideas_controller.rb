# -*- coding: no-conversion -*-
class IdeasController < ApplicationController
  before_filter :login_required
  before_filter :pre_load
  def pre_load
    @idea = Idea.find(params[:id]) if params[:id]
  end

  def index
    @ideas = Idea.all
  end

  def new
    @idea = Idea.new
  end

  def create
    @idea = current_user.ideas.build params[:idea]
    return redirect_to :action => :index if @idea.save
    render :action => :new
  end

  def create_for_story
    @idea = current_user.ideas.create params[:idea]
    return render :partial => 'ideas/parts/for_story', :locals => {:story => @idea.source_story}
  end

  def mine
    @ideas = current_user.ideas
    render 'ideas/index'
  end

  def show
  end

  def index
    @ideas = Idea.all
  end

  def edit
  end

  def update
    return redirect_to ideas_path if @idea.update_attributes params[:idea]
    render :action => :edit
  end

  def destroy
    @idea.destroy
    render :text => '想法成功删除'
  end
end
